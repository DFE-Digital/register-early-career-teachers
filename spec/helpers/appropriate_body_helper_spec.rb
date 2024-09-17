require 'rails_helper'

RSpec.describe AppropriateBodyHelper, type: 'helper' do
  describe "#induction_programme_choices" do
    it "returns an array of InductionProgrammeChoice" do
      expect(induction_programme_choices).to be_an(Array)
      expect(induction_programme_choices).to all(be_a(AppropriateBodyHelper::InductionProgrammeChoice))
    end

    it "has keys for the old (pre-2025) induction choices" do
      expect(induction_programme_choices.map(&:identifier)).to eql(%w[cip fip diy])
    end
  end
end
