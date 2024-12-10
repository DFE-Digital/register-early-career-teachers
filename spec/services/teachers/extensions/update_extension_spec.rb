require "rails_helper"

RSpec.describe Teachers::Extensions::UpdateExtension do
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:extension) { FactoryBot.create(:induction_extension, teacher: teacher, number_of_terms: 1) }
  let(:service) { described_class.new(extension, valid_params) }

  describe "#update_extension" do
    context "with valid params" do
      let(:valid_params) { { number_of_terms: 2 } }
      it "updates the extension attributes" do
        service.update_extension
        extension.reload

        expect(extension).to have_attributes(
          number_of_terms: valid_params[:number_of_terms]
        )
      end

      it "returns true" do
        expect(service.update_extension).to be true
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { number_of_terms: -1 } }
      let(:service) { described_class.new(extension, invalid_params) }

      it "does not update the extension" do
        # expect { service.update_extension }.to(not_change { extension.reload.attributes })
        expect { service.update_extension }.not_to(change { extension.reload.attributes })
      end

      it "returns false" do
        expect(service.update_extension).to be false
      end
    end
  end
end
