require 'rails_helper'

describe Schools::RegisterECT::ECT do
  let(:store) do
    OpenStruct.new(trn: "3002586",
                   date_of_birth: "11-10-1945",
                   trs_first_name: "Dusty",
                   trs_last_name: "Rhodes",
                   trs_date_of_birth: "1945-10-11",
                   trs_national_insurance_number: "OWAD23455",
                   email: "dusty@rhodes.com")
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
end
