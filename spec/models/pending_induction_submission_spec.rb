describe PendingInductionSubmission do
  it { is_expected.to be_a_kind_of(Interval) }

  describe "associations" do
    it { is_expected.to belong_to(:appropriate_body) }
  end

  describe "validation" do
    describe "trn" do
      it { is_expected.to validate_presence_of(:trn).on(:find_ect).with_message("Enter a TRN") }

      context "when the string contains 7 numeric digits" do
        %w[0000001 9999999].each do |value|
          it { is_expected.to allow_value(value).for(:trn) }
        end
      end

      context "when the string contains something other than 7 numeric digits" do
        %w[123456 12345678 ONE4567 123456!].each do |value|
          it { is_expected.not_to allow_value(value).for(:trn).on(:find_ect) }
        end
      end
    end

    describe "date_of_birth" do
      it { is_expected.to validate_presence_of(:date_of_birth).with_message("Enter a date of birth").on(:find_ect) }

      it { is_expected.to validate_inclusion_of(:date_of_birth).in_range(100.years.ago.to_date..18.years.ago.to_date).on(:find_ect).with_message("Teacher must be between 18 and 100 years old") }
    end

    describe "establishment_id" do
      it { is_expected.to allow_value(nil).for(:establishment_id) }

      describe "valid" do
        ["1111/111", "9999/999"].each do |id|
          it { is_expected.to allow_value(id).for(:establishment_id).on(:find_ect) }
        end
      end

      describe "invalid" do
        ["111/1111", "AAAA/BBB", "1234/12345"].each do |id|
          it { is_expected.not_to allow_value(id).for(:establishment_id).on(:find_ect).with_message("Enter an establishment ID in the format 1234/567") }
        end
      end
    end

    describe "induction_programme" do
      it { is_expected.to validate_inclusion_of(:induction_programme).in_array(%w[fip cip diy]).with_message("Choose an induction programme").on(:register_ect) }
    end

    describe "started_on" do
      it { is_expected.to validate_presence_of(:started_on).with_message("Enter a start date").on(:register_ect) }
    end

    describe "finished_on" do
      it { is_expected.to validate_presence_of(:finished_on).with_message("Enter a finish date").on(%i[release_ect record_outcome]) }
    end

    describe "number_of_terms" do
      it { is_expected.to validate_inclusion_of(:number_of_terms).in_range(0..16).with_message("Terms must be between 0 and 16").on(%i[release_ect record_outcome]) }
    end

    describe "confirmed" do
      it { is_expected.to validate_acceptance_of(:confirmed).on(:check_ect).with_message("Confirm if these details are correct or try your search again") }
    end

    describe "trs_qts_awarded_before_started_on" do
      let(:pending_induction_submission) { FactoryBot.build(:pending_induction_submission, started_on:, trs_qts_awarded: Date.new(2023, 5, 1)) }

      context "when trs_qts_awarded is before started_on" do
        let(:started_on) { Date.new(2023, 5, 2) }

        it "is valid" do
          pending_induction_submission.valid?(:register_ect)

          expect(pending_induction_submission.errors[:started_on]).to be_empty
        end
      end
      context "when trs_qts_awarded is after started_on" do
        let(:started_on) { Date.new(2023, 4, 1) }

        it "is invalid" do
          pending_induction_submission.valid?(:register_ect)

          expect(pending_induction_submission.errors[:started_on]).to include("Induction start date cannot be earlier than QTS award date (1 May 2023)")
        end
      end
    end
  end
end
