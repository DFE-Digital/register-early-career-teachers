RSpec.describe TeacherReferenceNumberValidator do
  let(:test_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :trn

      validates :trn, teacher_reference_number: true
    end
  end

  context "when the trn is valid" do
    valid_trns = ["12345", "RP99/12345", "RP / 1234567", "  R P 99 / 1234", "ZZ-123445 "]

    valid_trns.each do |trn|
      it "does not add any errors for trn - #{trn}" do
        subject = test_class.new(trn:)
        subject.valid?
        expect(subject.errors[:teacher_reference_number]).to be_empty
      end
    end
  end

  context "when the trn is invalid" do
    invalid_trns = [{ trn: "1234", error_message: "Teacher reference number must include at least 5 digits" },
                    { trn: "RP99/123457", error_message: "Teacher reference number cannot include more than 7 digits" },
                    { trn: "No-numbers", error_message: "Teacher reference number must include at least 5 digits" },
                    { trn: "", error_message: "Enter the teacher reference number (TRN)" }]

    invalid_trns.each do |item|
      it "adds an error for trn - #{item[:trn]} " do
        subject = test_class.new(trn: item[:trn])
        subject.valid?

        expect(subject.errors[:trn]).to include(item[:error_message])
      end
    end
  end
end
