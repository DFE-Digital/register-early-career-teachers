require 'rails_helper'

describe PendingInductionSubmission do
  it { is_expected.to be_a_kind_of(Interval) }

  describe "associations" do
    it { is_expected.to belong_to(:appropriate_body) }
  end

  describe "validation" do
    describe "trn" do
      it { is_expected.to validate_presence_of(:trn).with_message("Enter a TRN") }

      context "when the string contains 7 numeric digits" do
        %w[0000001 9999999].each do |value|
          it { is_expected.to allow_value(value).for(:trn) }
        end
      end

      context "when the string contains something other than 7 numeric digits" do
        %w[123456 12345678 ONE4567 123456!].each do |value|
          it { is_expected.not_to allow_value(value).for(:trn) }
        end
      end
    end

    describe "date_of_birth" do
      it { is_expected.to validate_presence_of(:date_of_birth).with_message("Enter a date of birth") }

      it { is_expected.to validate_inclusion_of(:date_of_birth).in_range(100.years.ago.to_date..18.years.ago.to_date).with_message("Teacher must be between 18 and 100 years old") }
    end

    describe "establishment_id" do
      it { is_expected.to allow_value(nil).for(:establishment_id) }

      describe "valid" do
        ["1111/111", "9999/999"].each do |id|
          it { is_expected.to allow_value(id).for(:establishment_id) }
        end
      end

      describe "invalid" do
        ["111/1111", "AAAA/BBB", "1234/12345"].each do |id|
          it { is_expected.not_to allow_value(id).for(:establishment_id).with_message("Enter an establishment ID in the format 1234/567") }
        end
      end
    end

    describe "induction_programme" do
      it { is_expected.to validate_inclusion_of(:induction_programme).in_array(%w[fip cip diy]).with_message("Choose an induction programme").on(:record_period) }
    end

    describe "number_of_terms" do
      it { is_expected.to validate_inclusion_of(:number_of_terms).in_range(0..16).with_message("Terms must be between 0 and 16").on(:record_period) }
    end
  end
end
