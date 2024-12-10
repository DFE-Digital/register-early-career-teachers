require 'rails_helper'

describe Admin::CurrentTeachers do
  describe '#current' do
    context 'with appropriate body IDs' do
      it 'returns teachers with ongoing induction periods for the given appropriate bodies' do
        ab1 = FactoryBot.create(:appropriate_body)
        ab2 = FactoryBot.create(:appropriate_body)
        teacher1 = FactoryBot.create(:teacher)
        teacher2 = FactoryBot.create(:teacher)
        teacher3 = FactoryBot.create(:teacher)

        FactoryBot.create(
          :induction_period,
          teacher: teacher1,
          appropriate_body: ab1,
          started_on: 1.month.ago.to_date,
          finished_on: nil,
          induction_programme: 'fip'
        )
        FactoryBot.create(
          :induction_period,
          teacher: teacher2,
          appropriate_body: ab2,
          started_on: 1.month.ago.to_date,
          finished_on: nil,
          induction_programme: 'fip'
        )
        FactoryBot.create(
          :induction_period,
          teacher: teacher3,
          appropriate_body: ab1,
          started_on: 2.months.ago.to_date,
          finished_on: 1.month.ago.to_date,
          induction_programme: 'fip'
        )

        result = described_class.new([ab1.id]).current

        expect(result).to include(teacher1)
        expect(result).not_to include(teacher2)
        expect(result).not_to include(teacher3)
      end
    end

    context 'with no appropriate body IDs' do
      it 'returns all teachers with ongoing induction periods' do
        teacher1 = FactoryBot.create(:teacher)
        teacher2 = FactoryBot.create(:teacher)

        FactoryBot.create(
          :induction_period,
          teacher: teacher1,
          started_on: 1.month.ago.to_date,
          finished_on: nil,
          induction_programme: 'fip'
        )
        FactoryBot.create(
          :induction_period,
          teacher: teacher2,
          started_on: 2.months.ago.to_date,
          finished_on: 1.month.ago.to_date,
          induction_programme: 'fip'
        )

        result = described_class.new([]).current

        expect(result).to include(teacher1)
        expect(result).not_to include(teacher2)
      end
    end

    it 'returns distinct teachers' do
      ab = FactoryBot.create(:appropriate_body)
      teacher = FactoryBot.create(:teacher)

      # First period: 3 months ago to 2 months ago
      FactoryBot.create(
        :induction_period,
        teacher: teacher,
        appropriate_body: ab,
        started_on: 3.months.ago.to_date,
        finished_on: 2.months.ago.to_date,
        induction_programme: 'fip'
      )

      # Second period: ongoing from 1 month ago
      FactoryBot.create(
        :induction_period,
        teacher: teacher,
        appropriate_body: ab,
        started_on: 1.month.ago.to_date,
        finished_on: nil,
        induction_programme: 'fip'
      )

      result = described_class.new([ab.id]).current

      expect(result.count).to eq(1)
    end
  end
end
