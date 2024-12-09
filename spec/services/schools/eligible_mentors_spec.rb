describe Schools::EligibleMentors do
  let(:school) { FactoryBot.create(:school) }
  let(:ect) { FactoryBot.create(:ect_at_school_period, :active, started_on: 2.years.ago) }

  subject do
    described_class.new(school).for_ect(ect)
  end

  describe '#for_ect' do
    context "when the school has no active mentors" do
      it { is_expected.to be_empty }
    end

    context "when the school has active mentors registered" do
      let!(:active_mentors) { FactoryBot.create_list(:mentor_at_school_period, 2, :active, school:, started_on: 2.years.ago) }

      it { is_expected.to match_array(active_mentors) }
    end

    context "when the ect is also a mentor at the school" do
      let!(:mentors_excluding_ect) { FactoryBot.create_list(:mentor_at_school_period, 2, :active, school:, started_on: 2.years.ago) }

      before do
        FactoryBot.create(:mentor_at_school_period, :active, school:, teacher: ect.teacher, started_on: 2.years.ago)
      end

      it { is_expected.to match_array(mentors_excluding_ect) }
    end
  end
end
