require 'rails_helper'

describe DateOfBirthValidator do
  let(:test_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :date_of_birth

      validates :date_of_birth, date_of_birth: true
    end
  end

  subject { test_class.new(date_of_birth:) }

  context "when date_of_birth is invalid" do
    context "when date is in an invalid format" do
      let(:date_of_birth) { { 1 => "invalid", 2 => "02", 3 => "30" } }

      it "adds an error" do
        subject.valid?
        expect(subject.errors[:date_of_birth]).to include("Enter the date of birth in the correct format, for example 12 03 1998")
      end
    end

    context "when the date_of_birth is more than 100 years ago" do
      let(:date_of_birth) { { 1 => (Time.zone.today.year - 101).to_s, 2 => "01", 3 => "01" } }

      it "adds an error" do
        subject.valid?
        expect(subject.errors[:date_of_birth]).to include("The teacher cannot be more than 100 years old")
      end
    end

    context "when the date_of_birth is in the future or indicates an age that is under 18" do
      let(:date_of_birth) { { 1 => (Time.zone.today.year - 17).to_s, 2 => Time.zone.today.month.to_s, 3 => Time.zone.today.day.to_s } }

      it "adds an error" do
        subject.valid?
        expect(subject.errors[:date_of_birth]).to include("The teacher cannot be less than 18 years old")
      end
    end
  end

  context "when the date_of_birth is valid" do
    let(:date_of_birth) { { 1 => (Time.zone.today.year - 30).to_s, 2 => "02", 3 => "15" } }

    it "does not add any errors" do
      subject.valid?
      expect(subject.errors[:date_of_birth]).to be_empty
    end
  end
end
