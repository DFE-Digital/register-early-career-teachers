describe Teachers::FullNameParser do
  let(:full_name) { "\t Mrs. Alison Walnut Curtains-Handbag (Maiden-name ) \n" }

  subject(:service) { described_class.new(full_name:) }

  describe '#first_name' do
    it "returns the first name part" do
      expect(service.first_name).to eq "Alison"
    end
  end

  describe '#last_name' do
    it "returns the last name part" do
      expect(service.last_name).to eq "Curtains-Handbag"
    end
  end

  describe "#parsed_name" do
    it "returns all the parsed name parts" do
      expect(service.parsed_name).to match_array %w[Alison Walnut Curtains-Handbag]
    end

    it "does not include titles" do
      expect(service.parsed_name).not_to include "Mrs."
    end

    it "does not include parenthesised text" do
      expect(service.parsed_name.join(" ")).not_to match(/\(|\)|Maiden-name/)
    end
  end
end
