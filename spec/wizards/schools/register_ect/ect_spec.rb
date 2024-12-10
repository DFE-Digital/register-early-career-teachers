require 'rails_helper'

describe Schools::RegisterECTWizard::ECT do
  let(:school) { FactoryBot.create(:school) }
  let(:store) do
    FactoryBot.build(:session_repository,
                     trn: "3002586",
                     date_of_birth: "11-10-1945",
                     trs_first_name: "Dusty",
                     trs_last_name: "Rhodes",
                     trs_date_of_birth: "1945-10-11",
                     trs_national_insurance_number: "OWAD23455",
                     email: "dusty@rhodes.com",
                     school_urn: school.urn,
                     corrected_name: nil)
  end

  subject(:ect) { described_class.new(store) }

  describe '#email' do
    it 'returns the email address' do
      expect(ect.email).to eq("dusty@rhodes.com")
    end
  end

  describe '#full_name' do
    it 'returns the full name of the ECT' do
      expect(ect.full_name).to eq("Dusty Rhodes")
    end

    context 'when corrected_name is set' do
      before do
        store.corrected_name = 'Randy Marsh'
      end

      it 'returns the corrected_name as the full name' do
        expect(ect.full_name).to eq('Randy Marsh')
      end
    end
  end

  describe '#govuk_date_of_birth' do
    it 'formats the date of birth in the govuk format' do
      expect(ect.govuk_date_of_birth).to eq("11 October 1945")
    end
  end

  describe '#in_trs?' do
    context "when trs_first_name has been set" do
      it 'returns true' do
        expect(ect.in_trs?).to be_truthy
      end
    end

    context "when trs_first_name has not been set or is blank" do
      before do
        store.trs_first_name = nil
      end

      it 'returns false' do
        expect(ect.in_trs?).to be_falsey
      end
    end
  end

  describe '#matches_trs_dob?' do
    context "when date_of_birth is blank" do
      before do
        store.date_of_birth = nil
      end

      it 'returns false' do
        expect(ect.matches_trs_dob?).to be_falsey
      end
    end

    context "when trs_date_of_birth is blank" do
      before do
        store.trs_date_of_birth = nil
      end

      it 'returns false' do
        expect(ect.matches_trs_dob?).to be_falsey
      end
    end

    context "when date_of_birth and trs_date_of_birth are different dates" do
      before do
        store.date_of_birth = "1935-10-11"
      end

      it 'returns false' do
        expect(ect.matches_trs_dob?).to be_falsey
      end
    end

    context "when date_of_birth and trs_date_of_birth are the same date" do
      it 'returns true' do
        expect(ect.matches_trs_dob?).to be_truthy
      end
    end
  end

  describe '#trn' do
    it 'returns the trn' do
      expect(ect.trn).to eq("3002586")
    end
  end

  describe '#trs_national_insurance_number' do
    it 'returns the national insurance number in trs' do
      expect(ect.trs_national_insurance_number).to eq("OWAD23455")
    end
  end

  describe '#register!' do
    let(:teacher) { Teacher.first }
    let(:ect_at_school_period) { teacher.ect_at_school_periods.first }

    it "creates a new ECT at the given school" do
      expect(Teacher.find_by_trn(ect.trn)).to be_nil

      ect.register!

      expect(teacher.trn).to eq(ect.trn)
      expect(ect_at_school_period.school_id).to eq(school.id)
      expect(ect_at_school_period.started_on).to eq(Date.current)
    end
  end
end
