describe Teachers::Search do
  describe '#search' do
    context 'in admin context' do
      context 'with appropriate_body_ids' do
        it 'filters teachers by the given appropriate bodies' do
          ab1 = FactoryBot.create(:appropriate_body)
          ab2 = FactoryBot.create(:appropriate_body)
          teacher1 = FactoryBot.create(:teacher)
          teacher2 = FactoryBot.create(:teacher)

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

          result = described_class.new(
            query_string: nil,
            appropriate_body_ids: [ab1.id]
          ).search

          expect(result).to include(teacher1)
          expect(result).not_to include(teacher2)
        end
      end

      context 'with no appropriate_body_ids' do
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
            finished_on: Date.current,
            induction_programme: 'fip'
          )

          result = described_class.new(
            query_string: nil,
            appropriate_body_ids: []
          ).search

          expect(result).to include(teacher1)
          expect(result).not_to include(teacher2)
        end
      end
    end

    context 'in appropriate body context' do
      context 'with appropriate_body' do
        it 'returns teachers for that appropriate body' do
          ab = FactoryBot.create(:appropriate_body)
          teacher1 = FactoryBot.create(:teacher)
          teacher2 = FactoryBot.create(:teacher)

          FactoryBot.create(
            :induction_period,
            teacher: teacher1,
            appropriate_body: ab,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )
          FactoryBot.create(
            :induction_period,
            teacher: teacher2,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )

          result = described_class.new(
            query_string: nil,
            appropriate_body: ab
          ).search

          expect(result).to include(teacher1)
          expect(result).not_to include(teacher2)
        end
      end

      context 'with no appropriate_body' do
        it 'returns no teachers' do
          FactoryBot.create(:teacher)

          result = described_class.new(appropriate_body: nil).search

          expect(result).to be_empty
        end
      end
    end

    context 'with search terms' do
      context 'when there are 7 digit numbers in the search string' do
        it 'searches for all present 7 digit numbers (TRNs)' do
          teacher = FactoryBot.create(:teacher, trn: '1234567')
          FactoryBot.create(
            :induction_period,
            teacher: teacher,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )

          result = described_class.new(
            query_string: 'the quick brown 1234567 jumped over the lazy 2345678'
          ).search

          expect(result).to include(teacher)
        end
      end

      context 'when the search string contains some text' do
        it 'initiates a full text search with the given search string' do
          teacher = FactoryBot.create(:teacher, first_name: 'Captain', last_name: 'Scrummy')
          FactoryBot.create(
            :induction_period,
            teacher: teacher,
            started_on: 1.month.ago.to_date,
            finished_on: nil,
            induction_programme: 'fip'
          )

          result = described_class.new(query_string: 'Captain Scrummy').search

          expect(result).to include(teacher)
        end
      end
    end

    context 'with ignored parameters' do
      it 'returns all teachers when all parameters are ignored' do
        teacher = FactoryBot.create(:teacher)
        FactoryBot.create(
          :induction_period,
          teacher: teacher,
          started_on: 1.month.ago.to_date,
          finished_on: nil,
          induction_programme: 'fip'
        )

        result = described_class.new.search

        expect(result).to include(teacher)
      end
    end

    it 'orders results by last name, first name, and id' do
      teacher1 = FactoryBot.create(:teacher, first_name: 'Alan', last_name: 'Smith')
      teacher2 = FactoryBot.create(:teacher, first_name: 'Bob', last_name: 'Smith')
      teacher3 = FactoryBot.create(:teacher, first_name: 'Alan', last_name: 'Jones')

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
        started_on: 1.month.ago.to_date,
        finished_on: nil,
        induction_programme: 'fip'
      )
      FactoryBot.create(
        :induction_period,
        teacher: teacher3,
        started_on: 1.month.ago.to_date,
        finished_on: nil,
        induction_programme: 'fip'
      )

      result = described_class.new.search

      expect(result.to_a).to eq([teacher3, teacher1, teacher2])
    end
  end
end
