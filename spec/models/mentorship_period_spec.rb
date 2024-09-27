describe MentorshipPeriod do
  describe "associations" do
    it { is_expected.to belong_to(:mentee).class_name("ECTAtSchoolPeriod").with_foreign_key(:ect_at_school_period_id).inverse_of(:mentorship_periods) }
    it { is_expected.to belong_to(:mentor).class_name("MentorAtSchoolPeriod").with_foreign_key(:mentor_at_school_period_id).inverse_of(:mentorship_periods) }
  end

  describe "validations" do
    let!(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period, :active, started_on: 2.years.ago) }
    let!(:mentor_at_school_period) { FactoryBot.create(:mentor_at_school_period, :active, started_on: 2.years.ago) }
    let(:started_on) { 2.months.ago }
    let(:finished_on) { nil }

    subject do
      FactoryBot.build(
        :mentorship_period,
        started_on:,
        finished_on:,
        mentee: ect_at_school_period,
        mentor: mentor_at_school_period
      )
    end

    it { is_expected.to validate_presence_of(:started_on) }
    it { is_expected.to validate_presence_of(:ect_at_school_period_id) }
    it { is_expected.to validate_presence_of(:mentor_at_school_period_id) }

    describe 'overlapping periods' do
      context '#mentee_distinct_period' do
        PeriodHelpers::PeriodExamples.period_examples.each do |test|
          context test.description do
            let(:mentor_at_school_period) do
              FactoryBot.create(:mentor_at_school_period, started_on: 5.years.ago, finished_on: nil)
            end

            let(:ect_at_school_period) do
              FactoryBot.create(:ect_at_school_period, started_on: 5.years.ago, finished_on: nil)
            end

            let!(:existing_period) do
              FactoryBot.create(:mentorship_period, mentee: ect_at_school_period, mentor: mentor_at_school_period, started_on: test.existing_period_range.first, finished_on: test.existing_period_range.last)
            end

            it "is #{test.expected_valid ? 'valid' : 'invalid'}" do
              mentorship_period = FactoryBot.build(:mentorship_period, mentee: ect_at_school_period, mentor: mentor_at_school_period, started_on: test.new_period_range.first, finished_on: test.new_period_range.last)
              mentorship_period.valid?
              message = 'Mentee periods cannot overlap'

              if test.expected_valid
                expect(mentorship_period.errors.messages[:base]).not_to include(message)
              else
                expect(mentorship_period.errors.messages[:base]).to include(message)
              end
            end
          end
        end
      end
    end

    describe 'period containment' do
      describe '#enveloped_by_ect_at_school_period' do
        context 'when the ECT at school period contains the mentorship period' do
          let!(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period, started_on: 4.months.ago, finished_on: 1.month.ago) }
          let!(:mentor_at_school_period) { FactoryBot.create(:mentor_at_school_period, started_on: 4.months.ago, finished_on: 1.month.ago) }

          subject! { FactoryBot.create(:mentorship_period, started_on: 3.months.ago, finished_on: 2.months.ago, mentee: ect_at_school_period, mentor: mentor_at_school_period) }

          it 'is valid' do
            expect(subject).to be_valid
          end
        end

        context 'when the mentorship period extends beyond the teacher and mentor at school periods' do
          let!(:ect_at_school_period) { FactoryBot.create(:ect_at_school_period, started_on: 4.months.ago, finished_on: 1.month.ago) }
          let!(:mentor_at_school_period) { FactoryBot.create(:mentor_at_school_period, started_on: 4.months.ago, finished_on: 1.month.ago) }

          subject { FactoryBot.build(:mentorship_period, started_on: 5.months.ago, finished_on: 1.month.ago, mentee: ect_at_school_period, mentor: mentor_at_school_period) }

          it 'has an appropriate error message about the ECT at school period' do
            subject.valid?

            expect(subject.errors.messages[:base]).to include("Date range is not contained by the ECT at school period")
          end

          it 'has an appropriate error message about the mentor at school period' do
            subject.valid?

            expect(subject.errors.messages[:base]).to include("Date range is not contained by the mentor at school period")
          end
        end
      end
    end
  end

  describe "scopes" do
    describe ".for_mentee" do
      it "returns only periods for the specified mentee" do
        expect(MentorshipPeriod.for_mentee(123).to_sql).to end_with(%(WHERE "mentorship_periods"."ect_at_school_period_id" = 123))
      end
    end

    describe ".for_mentor" do
      it "returns only periods for the specified mentor" do
        expect(MentorshipPeriod.for_mentor(456).to_sql).to end_with(%(WHERE "mentorship_periods"."mentor_at_school_period_id" = 456))
      end
    end

    describe ".mentee_siblings_of" do
      let!(:mentee) { FactoryBot.create(:ect_at_school_period, :active, started_on: '2021-01-01') }
      let!(:mentor) { FactoryBot.create(:mentor_at_school_period, :active, started_on: '2021-01-01') }
      let!(:period_1) { FactoryBot.create(:mentorship_period, mentee:, mentor:, started_on: '2022-01-01', finished_on: '2022-06-01') }
      let!(:period_2) { FactoryBot.create(:mentorship_period, mentee:, mentor:, started_on: '2022-06-01', finished_on: '2023-01-01') }

      let!(:unrelated_mentee) { FactoryBot.create(:ect_at_school_period, :active, started_on: '2021-01-01') }
      let!(:unrelated_period) { FactoryBot.create(:mentorship_period, mentor:, mentee: unrelated_mentee, started_on: '2022-06-01', finished_on: '2023-01-01') }

      subject { MentorshipPeriod.mentee_siblings_of(period_1) }

      it "only returns records that belong to the same mentee" do
        expect(subject).to include(period_2)
      end

      it "doesn't include itself" do
        expect(subject).not_to include(period_1)
      end

      it "doesn't include periods that belong to other mentees" do
        expect(subject).not_to include(unrelated_period)
      end
    end
  end
end
