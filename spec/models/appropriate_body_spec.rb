describe AppropriateBody do
  describe "associations" do
    it { is_expected.to have_many(:induction_periods) }
  end

  describe "validations" do
    subject { FactoryBot.build(:appropriate_body) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    it { is_expected.to validate_presence_of(:local_authority_code).with_message('Enter a local authority code') }
    it { is_expected.to validate_inclusion_of(:local_authority_code).in_range(100..999).with_message('Must be a number between 100 and 999') }

    it { is_expected.to validate_presence_of(:establishment_number).with_message('Enter a establishment number') }
    it { is_expected.to validate_inclusion_of(:establishment_number).in_range(1000..9999).with_message('Must be a number between 1000 and 9999') }

    it "ensures local_authority_code and establishment_number are unique in combination" do
      ab_args = { local_authority_code: 123, establishment_number: 4567 }
      FactoryBot.create(:appropriate_body, name: "AB1", **ab_args)
      FactoryBot.build(:appropriate_body, name: "AB2", **ab_args).tap do |duplicate_ab|
        expect(duplicate_ab).to be_invalid
        expect(duplicate_ab.errors.messages.fetch(:local_authority_code)).to include(/local authority code and establishment number already exists/)
      end
    end
  end

  describe '#establishment_id' do
    let(:local_authority_code) { 123 }
    let(:establishment_number) { 4567 }

    subject { FactoryBot.create(:appropriate_body, local_authority_code:, establishment_number:) }

    it "is the local_authority_code and establishment_number separated by a '/'" do
      expect(subject.establishment_id).to eql("#{local_authority_code}/#{establishment_number}")
    end
  end
end
