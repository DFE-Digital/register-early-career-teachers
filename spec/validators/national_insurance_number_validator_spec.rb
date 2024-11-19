# frozen_string_literal: true

require "rails_helper"

describe NationalInsuranceNumberValidator, type: :model do
  let(:test_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :national_insurance_number

      validates :national_insurance_number, national_insurance_number: true
    end
  end

  valid_national_insurance_numbers =
    [
      "Ab123456A",
      "AB123456   A",
      "ab 12 34 56 A",
      "A B 1 2 3 4 5 6 a",
    ]

  invalid_national_insurance_numbers =
    %w[DA123456A
       FA123456A
       IA123456A
       QA123456A
       UA123456A
       va123456A
       AD123456a
       AF123456A
       AI123456A
       AQ123456A
       AU123456A
       AV123456A
       AO123456A
       Bg123456A
       GB123456A
       kn123456A
       NK123456A
       NT123456A
       TN123456A
       ZZ123456A]

  context "when the National Insurance Number is valid" do
    valid_national_insurance_numbers.each do |national_insurance_number|
      it "does not add any errors for national insurance number = #{national_insurance_number}" do
        subject = test_class.new(national_insurance_number:)
        subject.valid?
        expect(subject.errors[:national_insurance_number]).to be_empty
      end
    end
  end

  context "when the National Insurance Number is invalid" do
    invalid_national_insurance_numbers.each do |national_insurance_number|
      it "adds an error for national insurance number = #{national_insurance_number}" do
        subject = test_class.new(national_insurance_number:)
        subject.valid?

        expect(subject.errors[:national_insurance_number]).to include("Enter a National Insurance Number in the correct format")
      end
    end
  end

  context "when the National Insurance Number is missing" do
    it "adds an error" do
      subject = test_class.new
      subject.valid?

      expect(subject.errors[:national_insurance_number]).to include("Enter a National Insurance Number")
    end
  end
end
