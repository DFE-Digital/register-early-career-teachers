require "rails_helper"

RSpec.describe Teachers::Extensions::CreateExtension do
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:service) { described_class.new(teacher, valid_params) }

  describe "#create_extension" do
    context "with valid params" do
      let(:valid_params) { { number_of_terms: 1 } }
      it "creates a new induction extension" do
        expect { service.create_extension }.to change(InductionExtension, :count).by(1)
      end

      it "associates the extension with the teacher" do
        service.create_extension
        expect(teacher.induction_extensions.last).to have_attributes(
          number_of_terms: valid_params[:number_of_terms]
        )
      end

      it "returns true" do
        expect(service.create_extension).to be true
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { number_of_terms: nil } }
      let(:service) { described_class.new(teacher, invalid_params) }

      it "does not create a new induction extension" do
        expect { service.create_extension }.not_to change(InductionExtension, :count)
      end

      it "returns false" do
        expect(service.create_extension).to be false
      end
    end
  end
end
