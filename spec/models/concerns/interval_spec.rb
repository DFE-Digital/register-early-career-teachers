describe Interval do
  describe "validations" do
    context "period dates" do
      context "when finished_on is earlier than started_on" do
        subject { DummyMentor.new(started_on: Date.yesterday, finished_on: 2.days.ago) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(finished_on: ["Must be later than :started_on"])
        end
      end

      context "when finished_on matches started_on" do
        subject { DummyMentor.new(started_on: Date.yesterday, finished_on: Date.yesterday) }

        before do
          subject.valid?
        end

        it "add an error" do
          expect(subject.errors.messages).to include(finished_on: ["Must be later than :started_on"])
        end
      end
    end
  end

  describe "scopes" do
    let!(:teacher_id) { FactoryBot.create(:teacher, name: "Teacher One").id }
    let!(:teacher_2_id) { FactoryBot.create(:teacher, name: "Teacher Two").id }
    let!(:school_id) { FactoryBot.create(:school, urn: "1234567").id }
    let!(:period_1) { DummyMentor.create(teacher_id:, school_id:, started_on: '2023-01-01', finished_on: '2023-06-01') }
    let!(:period_2) { DummyMentor.create(teacher_id:, school_id:, started_on: '2023-07-01', finished_on: '2023-12-01') }
    let!(:period_3) { DummyMentor.create(teacher_id:, school_id:, started_on: '2024-01-01', finished_on: nil) }
    let!(:teacher_2_period) do
      DummyMentor.create(teacher_id: teacher_2_id, school_id:, started_on: '2023-02-01', finished_on: '2023-07-01')
    end

    describe ".extending_later_than" do
      it "returns periods with finished_on later than the specified date or not finished" do
        expect(DummyMentor.extending_later_than('2023-05-01')).to match_array([period_1, period_2, period_3, teacher_2_period])
      end

      it "does not return periods finished before the specified date" do
        expect(DummyMentor.extending_later_than('2023-07-02')).to match_array([period_2, period_3])
      end
    end

    describe ".starting_earlier_than" do
      it "returns periods with started_on earlier than the specified date" do
        expect(DummyMentor.starting_earlier_than('2023-08-01')).to match_array([period_1, period_2, teacher_2_period])
      end

      it "does not return periods with started_on on or after the specified date" do
        expect(DummyMentor.starting_earlier_than('2023-01-01')).to be_empty
      end
    end

    describe ".overlapping" do
      it "returns periods overlapping with the specified date range" do
        expect(DummyMentor.overlapping('2023-02-01', '2023-10-01')).to match_array([period_1, period_2, teacher_2_period])
      end

      it "returns periods starting after the specified start date if end date is nil" do
        expect(DummyMentor.overlapping('2024-01-01', nil)).to match_array([period_3])
      end

      it "does not return periods outside the specified date range" do
        expect(DummyMentor.overlapping('2022-01-01', '2022-12-31')).to be_empty
      end
    end
  end
end

class DummyMentor < ApplicationRecord
  include Interval

  self.table_name = "mentor_at_school_periods"
end
