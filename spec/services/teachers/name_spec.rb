require 'rails_helper'

describe Teachers::Name do
  describe '#full_name' do
    subject { Teachers::Name.new(teacher) }

    context 'when a corrected_name is set' do
      let(:teacher) { FactoryBot.build(:teacher) }

      it 'returns the corrected name' do
        expect(teacher.corrected_name).to be_present
        expect(subject.full_name).to eql(teacher.corrected_name)
      end
    end

    context 'when no corrected_name is set' do
      let(:teacher) { FactoryBot.build(:teacher, corrected_name: nil) }

      it 'returns the first name followed by the last name' do
        expect(subject.full_name).to eql(%(#{teacher.first_name} #{teacher.last_name}))
      end
    end
  end
end
