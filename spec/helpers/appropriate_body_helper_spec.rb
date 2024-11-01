RSpec.describe AppropriateBodyHelper, type: :helper do
  include GovukComponentsHelper
  include GovukLinkHelper
  include GovukVisuallyHiddenHelper

  describe "#induction_programme_choices" do
    it "returns an array of InductionProgrammeChoice" do
      expect(induction_programme_choices).to be_an(Array)
      expect(induction_programme_choices).to all(be_a(AppropriateBodyHelper::InductionProgrammeChoice))
    end

    it "has keys for the old (pre-2025) induction choices" do
      expect(induction_programme_choices.map(&:identifier)).to eql(%w[cip fip diy])
    end
  end

  describe "#summary_card_for_teacher" do
    let(:teacher) { FactoryBot.create(:teacher) }

    it "builds a summary card for a teacher" do
      expect(summary_card_for_teacher(teacher)).to include(
        CGI.escapeHTML(teacher.first_name),
        CGI.escapeHTML(teacher.last_name)
      )
    end

    context "when the teacher has induction periods" do
      let(:expected_date) { "2 October 2022" }
      let!(:induction_period) do
        FactoryBot.create(
          :induction_period,
          appropriate_body: FactoryBot.create(:appropriate_body),
          teacher:,
          started_on: Date.parse(expected_date)
        )
      end

      it "displays the most recent induction start date" do
        expect(summary_card_for_teacher(teacher)).to include(expected_date)
      end
    end
  end
end
