describe TrainingPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:ect_at_school_period).class_name("ECTAtSchoolPeriod").inverse_of(:training_periods) }
    it { is_expected.to belong_to(:mentor_at_school_period).inverse_of(:training_periods) }
    it { is_expected.to belong_to(:provider_partnership) }
    it { is_expected.to have_many(:declarations).inverse_of(:training_period) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:started_on) }
    it { is_expected.to validate_presence_of(:provider_partnership_id) }

    context "exactly one id of trainee present" do
      context "when ect_at_school_period_id and mentor_at_school_period_id are all nil" do
        subject do
          FactoryBot.build(:training_period, ect_at_school_period_id: nil, mentor_at_school_period_id: nil)
        end

        it "add an error" do
          subject.valid?
          expect(subject.errors.messages[:base]).to include("Id of trainee missing")
        end
      end

      context "when ect_at_school_period_id and mentor_at_school_period_id are all set" do
        subject do
          FactoryBot.build(:training_period, ect_at_school_period_id: 200, mentor_at_school_period_id: 300)
        end

        it "add an error" do
          subject.valid?
          expect(subject.errors.messages).to include(base: ["Only one id of trainee required. Two given"])
        end
      end
    end

    describe 'overlapping periods' do
      context '#trainee_distinct_period' do
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

      context '#mentor_distinct_period' do
        PeriodHelpers::PeriodExamples.period_examples.each do |test|
          context test.description do
            let(:mentor_at_school_period) do
              FactoryBot.create(:mentor_at_school_period, started_on: 5.years.ago, finished_on: nil)
            end

            let!(:existing_period) do
              FactoryBot.create(:training_period, :for_mentor, mentor_at_school_period:, started_on: test.existing_period_range.first, finished_on: test.existing_period_range.last)
            end

            it "is #{test.expected_valid ? 'valid' : 'invalid'}" do
              training_period = FactoryBot.build(:training_period, :for_mentor, mentor_at_school_period:, started_on: test.new_period_range.first, finished_on: test.new_period_range.last)
              training_period.valid?
              message = 'Mentor periods cannot overlap'

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
  end

  describe "scopes" do
    describe ".for_ect" do
      it "returns training periods only for the specified ect at school period" do
        expect(TrainingPeriod.for_ect(123).to_sql).to end_with(%(WHERE "training_periods"."ect_at_school_period_id" = 123))
      end
    end

    describe ".for_mentor" do
      it "returns training periods only for the specified mentor at school period" do
        expect(TrainingPeriod.for_mentor(456).to_sql).to end_with(%(WHERE "training_periods"."mentor_at_school_period_id" = 456))
      end
    end

    describe ".trainee_siblings_of" do
      let!(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period, :active, started_on: '2021-01-01') }
      let!(:training_period_1) { FactoryBot.create(:training_period, ect_at_school_period:, started_on: '2022-01-01', finished_on: '2022-06-01') }
      let!(:training_period_2) { FactoryBot.create(:training_period, ect_at_school_period:, started_on: '2022-06-01', finished_on: '2023-01-01') }

      let!(:unrelated_ect_at_school_period) do
        FactoryBot.create(:ect_at_school_period, :active, started_on: '2021-01-01')
      end

      let!(:unrelated_training_period) do
        FactoryBot.create(:training_period, ect_at_school_period: unrelated_ect_at_school_period, started_on: '2022-06-01', finished_on: '2023-01-01')
      end

      subject { TrainingPeriod.trainee_siblings_of(training_period_1) }

      it "only returns records that belong to the same trainee" do
        expect(subject).to include(training_period_2)
      end

      it "doesn't include itself" do
        expect(subject).not_to include(training_period_1)
      end

      it "doesn't include periods that belong to other trainee" do
        expect(subject).not_to include(unrelated_training_period)
      end
    end

    describe ".mentor_siblings_of" do
      let!(:mentor_at_school_period) { FactoryBot.create(:mentor_at_school_period, :active, started_on: '2021-01-01') }
      let!(:training_period_1) { FactoryBot.create(:training_period, :for_mentor, mentor_at_school_period:, started_on: '2022-01-01', finished_on: '2022-06-01') }
      let!(:training_period_2) { FactoryBot.create(:training_period, :for_mentor, mentor_at_school_period:, started_on: '2022-06-01', finished_on: '2023-01-01') }

      let!(:unrelated_mentor_at_school_period) do
        FactoryBot.create(:mentor_at_school_period, :active, started_on: '2021-01-01')
      end

      let!(:unrelated_training_period) do
        FactoryBot.create(:training_period, :for_mentor, mentor_at_school_period: unrelated_mentor_at_school_period, started_on: '2022-06-01', finished_on: '2023-01-01')
      end

      subject { TrainingPeriod.mentor_siblings_of(training_period_1) }

      it "only returns records that belong to the same mentee" do
        expect(subject).to include(training_period_2)
      end

      it "doesn't include itself" do
        expect(subject).not_to include(training_period_1)
      end

      it "doesn't include periods that belong to other mentees" do
        expect(subject).not_to include(unrelated_training_period)
      end
    end
  end
end
