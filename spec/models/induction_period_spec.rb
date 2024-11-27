describe InductionPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:appropriate_body) }
    it { is_expected.to belong_to(:teacher) }
  end

  describe "validations" do
    subject { FactoryBot.build(:induction_period) }

    it { is_expected.to validate_presence_of(:appropriate_body_id) }

    describe 'overlapping periods' do
      let(:teacher) { FactoryBot.create(:teacher) }
      let(:appropriate_body) { FactoryBot.create(:appropriate_body) }

      context '#teacher_distinct_period' do
        PeriodHelpers::PeriodExamples.period_examples.each do |test|
          context test.description do
            let!(:existing_period) do
              FactoryBot.create(:induction_period, teacher:, started_on: test.existing_period_range.first, finished_on: test.existing_period_range.last)
            end

            it "is #{test.expected_valid ? 'valid' : 'invalid'}" do
              induction_period = FactoryBot.build(:induction_period, teacher:, started_on: test.new_period_range.first, finished_on: test.new_period_range.last)
              induction_period.valid?
              message = 'Induction periods cannot overlap'

              if test.expected_valid
                expect(induction_period.errors.messages[:base]).not_to include(message)
              else
                expect(induction_period.errors.messages[:base]).to include(message)
              end
            end
          end
        end
      end
    end

    it { is_expected.to validate_inclusion_of(:induction_programme).in_array(%w[fip cip diy]).with_message("Choose an induction programme") }

    describe "number_of_terms" do
      context "when finished_on is empty" do
        subject { FactoryBot.build(:induction_period, :active) }
        it { is_expected.not_to validate_presence_of(:number_of_terms) }
      end

      context "when finished_on is present" do
        subject { FactoryBot.build(:induction_period) }
        it { is_expected.to validate_presence_of(:number_of_terms).with_message("Enter a number of terms") }
      end
    end

    describe "number_of_terms_for_ongoing_induction_period" do
      let(:appropriate_body) { FactoryBot.create(:appropriate_body) }
      let(:teacher) { FactoryBot.create(:teacher) }

      subject do
        FactoryBot.build(:induction_period,
                         appropriate_body: appropriate_body,
                         teacher: teacher,
                         finished_on: Date.current)
      end

      context "when finished_on is blank" do
        before { subject.finished_on = nil }
        it "is valid" do
          expect(subject).to be_valid
        end
      end

      context "when number_of_terms is blank" do
        before { subject.number_of_terms = nil }
        it "is valid" do
          subject.finished_on = nil
          expect(subject).to be_valid
        end
      end

      context "when number_of_terms is 0" do
        before { subject.number_of_terms = 0 }
        it "is valid" do
          expect(subject).to be_valid
        end
      end

      context "when number_of_terms is 1 or greater" do
        before { subject.number_of_terms = 1 }
        it "is valid" do
          expect(subject).to be_valid
        end
      end

      context "when number_of_terms is between 0 and 1" do
        before { subject.number_of_terms = 0.5 }

        it "is invalid" do
          expect(subject).not_to be_valid
        end

        it "adds the correct error message" do
          subject.valid?
          expect(subject.errors[:number_of_terms]).to include(
            "Partial terms can only be recorded after completing a full term of induction. If the early career teacher has done less than one full term of induction they cannot record partial terms and the number inputted should be 0."
          )
        end
      end
    end
  end

  describe "scopes" do
    describe ".for_teacher" do
      it "returns induction periods only for the specified ect at school period" do
        expect(InductionPeriod.for_teacher(123).to_sql).to end_with(%(WHERE "induction_periods"."teacher_id" = 123))
      end
    end

    describe ".for_appropriate_body" do
      it "returns induction periods only for the specified appropriate_body" do
        expect(InductionPeriod.for_appropriate_body(456).to_sql).to end_with(%( WHERE "induction_periods"."appropriate_body_id" = 456))
      end
    end

    describe ".siblings_of" do
      let!(:teacher) { FactoryBot.create(:teacher) }
      let!(:induction_period_1) { FactoryBot.create(:induction_period, teacher:, started_on: '2022-01-01', finished_on: '2022-06-01') }
      let!(:induction_period_2) { FactoryBot.create(:induction_period, teacher:, started_on: '2022-06-01', finished_on: '2023-01-01') }
      let!(:unrelated_induction_period) { FactoryBot.create(:induction_period, started_on: '2022-06-01', finished_on: '2023-01-01') }

      subject { InductionPeriod.siblings_of(induction_period_1) }

      it "only returns records that belong to the same mentee" do
        expect(subject).to include(induction_period_2)
      end

      it "doesn't include itself" do
        expect(subject).not_to include(induction_period_1)
      end

      it "doesn't include periods that belong to other mentees" do
        expect(subject).not_to include(unrelated_induction_period)
      end
    end
  end
end
