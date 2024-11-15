describe Builders::Teacher do
  let(:trn) { "1234567" }
  let(:full_name) { "Chester Thompson" }

  subject(:processor) { described_class.new(trn:, full_name:) }

  describe '#process!' do
    it "creates a new Teacher record" do
      expect {
        subject.process!
      }.to change { Teacher.count }.by(1)
    end

    it "sets the TRN correctly" do
      teacher = subject.process!
      expect(teacher.trn).to eq trn
    end

    it "sets the first name" do
      teacher = subject.process!
      expect(teacher.first_name).to eq "Chester"
    end

    it "sets the last name" do
      teacher = subject.process!
      expect(teacher.last_name).to eq "Thompson"
    end

    context "when a legacy_id is supplied" do
      let(:legacy_id) { SecureRandom.uuid }

      it "stores the legacy_id" do
        teacher = described_class.new(trn:, full_name:, legacy_id:).process!
        expect(teacher.legacy_id).to eq legacy_id
      end
    end

    context "when a teacher with the same TRN already exists" do
      before do
        FactoryBot.create(:teacher, trn:)
      end

      it "raises an error" do
        expect {
          subject.process!
        }.to raise_error(ActiveRecord::RecordInvalid).with_message("Validation failed: TRN TRN already exists")
      end
    end
  end
end
