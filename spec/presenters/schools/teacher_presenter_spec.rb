# frozen_string_literal: true

require 'rails_helper'

describe Schools::TeacherPresenter, type: :presenter do
  let(:attributes) do
    OpenStruct.new({
      "trn" => "3002586",
      "trs_first_name" => "Dusty",
      "trs_last_name" => "Rhodes",
      "trs_date_of_birth" => "1945-10-11",
      "trs_national_insurance_number" => "OWAD23455",
      "email" => "dusty@rhodes.com",
    })
  end

  subject(:presenter) { described_class.new(attributes) }

  describe '#full_name' do
    it 'returns the full name of the ECT' do
      expect(presenter.full_name).to eq("Dusty Rhodes")
    end
  end

  describe '#govuk_date_of_birth' do
    it 'formats the date of birth in the govuk format' do
      expect(presenter.govuk_date_of_birth).to eq("11 October 1945")
    end
  end

  describe '#trn' do
    it 'returns the trn' do
      expect(presenter.trn).to eq("3002586")
    end
  end

  describe '#national_insurance_number' do
    it 'returns the national insurance number' do
      expect(presenter.national_insurance_number).to eq("OWAD23455")
    end
  end

  describe '#email' do
    it 'returns the email address' do
      expect(presenter.email).to eq("dusty@rhodes.com")
    end
  end
end
