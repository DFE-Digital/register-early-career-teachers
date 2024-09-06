describe MentorshipPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:mentee).class_name("ECTAtSchoolPeriod").with_foreign_key(:ect_at_school_period_id).inverse_of(:mentorship_periods) }
    it { is_expected.to belong_to(:mentor).class_name("MentorAtSchoolPeriod").with_foreign_key(:mentor_at_school_period_id).inverse_of(:mentorship_periods) }
  end

  describe "validations" do
    subject { FactoryBot.create(:mentorship_period) }

    it {
      is_expected.to validate_uniqueness_of(:finished_on)
                       .scoped_to(:ect_at_school_period_id)
                       .allow_nil
                       .with_message("matches the end date of an existing period for mentee")
    }
    it {
      is_expected.to validate_uniqueness_of(:started_on)
                       .scoped_to(:ect_at_school_period_id)
                       .with_message("matches the start date of an existing period for mentee")
    }
    it { is_expected.to validate_presence_of(:started_on) }
    it { is_expected.to validate_presence_of(:ect_at_school_period_id) }
    it { is_expected.to validate_presence_of(:mentor_at_school_period_id) }

    context "mentee distinct period" do
      context "when the period has not finished yet" do
        context "when the mentee has a sibling mentorship periods starting later" do
          let!(:existing_period) { FactoryBot.create(:mentorship_period) }
          let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
          let(:started_on) { existing_period.started_on - 1.year }

          subject { FactoryBot.build(:mentorship_period, ect_at_school_period_id:, started_on:, finished_on: nil) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Mentee periods cannot overlap"])
          end
        end
      end

      context "when the period has end date" do
        context "when the mentee has a sibling mentorship_period overlapping" do
          let!(:existing_period) { FactoryBot.create(:mentorship_period) }
          let(:ect_at_school_period_id) { existing_period.ect_at_school_period_id }
          let(:started_on) { existing_period.finished_on - 1.day }
          let(:finished_on) { started_on + 1.day }

          subject { FactoryBot.build(:mentorship_period, ect_at_school_period_id:, started_on:, finished_on:) }

          before do
            subject.valid?
          end

          it "add an error" do
            expect(subject.errors.messages).to include(base: ["Mentee periods cannot overlap"])
          end
        end
      end
    end
  end

  describe "scopes" do
    let!(:mentee) { FactoryBot.create(:ect_at_school_period) }
    let!(:mentor) { FactoryBot.create(:mentor_at_school_period) }
    let!(:period_1) { FactoryBot.create(:mentorship_period, mentee:, mentor:, started_on: '2023-01-01', finished_on: '2023-06-01') }
    let!(:period_2) { FactoryBot.create(:mentorship_period, mentee:, started_on: "2023-06-01", finished_on: "2024-01-01") }
    let!(:period_3) { FactoryBot.create(:mentorship_period, mentee:, mentor:, started_on: '2024-01-01', finished_on: nil) }
    let!(:mentee_2_period) { FactoryBot.create(:mentorship_period, mentor:, started_on: '2023-02-01', finished_on: '2023-07-01') }

    describe ".for_mentee" do
      it "returns mentorship periods only for the specified mentee" do
        expect(described_class.for_mentee(mentee.id)).to match_array([period_1, period_2, period_3])
      end
    end

    describe ".for_mentor" do
      it "returns mentorship periods only for the specified mentor" do
        expect(described_class.for_mentor(mentor.id)).to match_array([period_1, period_3, mentee_2_period])
      end
    end

    describe ".mentee_siblings_of" do
      let(:mentorship_period) { FactoryBot.build(:mentorship_period, mentee:, mentor:, started_on: "2022-01-01", finished_on: "2023-01-01") }

      it "returns mentorship periods only for the specified instance's mentee excluding the instance" do
        expect(described_class.mentee_siblings_of(mentorship_period)).to match_array([period_1, period_2, period_3])
      end
    end
  end
end
