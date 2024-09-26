describe InductionPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:appropriate_body) }
    it { is_expected.to belong_to(:ect_at_school_period).inverse_of(:induction_periods) }
  end

  describe "validations" do
    let(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period, started_on: 2.years.ago, finished_on: nil) }
    subject { FactoryBot.build(:induction_period, ect_at_school_period:) }

    it { is_expected.to validate_presence_of(:appropriate_body_id) }
    it { is_expected.to validate_presence_of(:ect_at_school_period_id) }

    describe 'overlapping periods' do
      context '#teacher_distinct_period' do
        PeriodHelpers::PeriodExamples.period_examples.each do |test|
          context test.description do
            let(:ect_at_school_period) do
              FactoryBot.create(:ect_at_school_period, started_on: 5.years.ago, finished_on: nil)
            end

            let!(:existing_period) do
              FactoryBot.create(:training_period, ect_at_school_period:, started_on: test.existing_period_range.first, finished_on: test.existing_period_range.last)
            end

            it "is #{test.expected_valid ? 'valid' : 'invalid'}" do
              training_period = FactoryBot.build(:training_period, ect_at_school_period:, started_on: test.new_period_range.first, finished_on: test.new_period_range.last)
              training_period.valid?
              message = 'Trainee periods cannot overlap'

              if test.expected_valid
                expect(training_period.errors.messages[:base]).not_to include(message)
              else
                expect(training_period.errors.messages[:base]).to include(message)
              end
            end
          end
        end
      end
    end

    describe '#enveloped_by_ect_at_school_period' do
      context 'when the ECT at school period contains the induction period' do
        let(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period, started_on: 4.months.ago, finished_on: 1.month.ago) }

        subject! { FactoryBot.create(:induction_period, started_on: 3.months.ago, finished_on: 2.months.ago, ect_at_school_period:) }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'when the induction period extends beyond the teacher at school period' do
        let!(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period, started_on: 4.months.ago, finished_on: 1.month.ago) }

        subject { FactoryBot.build(:induction_period, started_on: 5.months.ago, finished_on: 1.month.ago, ect_at_school_period:) }

        it 'has an appropriate error message about the ECT at school period' do
          subject.valid?

          expect(subject.errors.messages[:base]).to include("Date range is not contained by the ECT at school period")
        end
      end
    end

    it { is_expected.to validate_inclusion_of(:induction_programme).in_array(%w[fip cip diy]).with_message("Choose an induction programme") }

    describe "number_of_terms" do
      context "when finished_on is empty" do
        subject { FactoryBot.build(:induction_period, finished_on: nil) }
        it { is_expected.not_to validate_presence_of(:number_of_terms) }
      end

      context "when finished_on is present" do
        subject { FactoryBot.build(:induction_period) }
        it { is_expected.to validate_presence_of(:number_of_terms).with_message("Enter a number of terms") }
      end
    end
  end

  describe "scopes" do
    describe ".for_ect" do
      it "returns induction periods only for the specified ect at school period" do
        expect(InductionPeriod.for_ect(123).to_sql).to end_with(%(WHERE "induction_periods"."ect_at_school_period_id" = 123))
      end
    end

    describe ".for_appropriate_body" do
      it "returns induction periods only for the specified appropriate_body" do
        expect(InductionPeriod.for_appropriate_body(456).to_sql).to end_with(%( WHERE "induction_periods"."appropriate_body_id" = 456))
      end
    end

    describe ".siblings_of" do
      let!(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period, :active, started_on: '2021-01-01') }
      let!(:induction_period_1) { FactoryBot.create(:induction_period, ect_at_school_period:, started_on: '2022-01-01', finished_on: '2022-06-01') }
      let!(:induction_period_2) { FactoryBot.create(:induction_period, ect_at_school_period:, started_on: '2022-06-01', finished_on: '2023-01-01') }

      let!(:unrelated_ect_at_school_period) do
        FactoryBot.create(:ect_at_school_period, :active, started_on: '2021-01-01')
      end

      let!(:unrelated_induction_period) do
        FactoryBot.create(:induction_period, ect_at_school_period: unrelated_ect_at_school_period, started_on: '2022-06-01', finished_on: '2023-01-01')
      end

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
