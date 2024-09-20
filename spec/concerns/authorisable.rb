require "rails_helper"

RSpec.shared_examples "Authorisable" do
  let(:user) { subject }

  describe "#can_access?" do
    %i[appropriate_body delivery_partner lead_provider school].each do |organisation_type|
      context "for an #{organisation_type}" do
        let(:organisation) { FactoryBot.create(organisation_type) }

        it "returns true when the user has the appropriate role" do
          FactoryBot.create(:"#{organisation_type}_role", user:, organisation_type => organisation)

          expect(user.can_access?(organisation)).to be true
        end

        it "returns false when the user does not have the appropriate role" do
          expect(user.can_access?(organisation)).to be false
        end
      end
    end

    it "returns true when authorised via DfE role" do
      FactoryBot.create(:dfe_role, user:)
      ab = FactoryBot.create(:appropriate_body)

      expect(user.can_access?(ab)).to be true
    end

    it "returns false when asked about an inaccessible model" do
      expect(user.can_access?(FactoryBot.build(:teacher))).to be false
    end
  end

  describe "#access_type" do
    context "when user has DfE role" do
      it "returns the DfE role type" do
        role_type = DfERole::ROLE_PRECEDENCE.sample
        FactoryBot.create(:dfe_role, user:, role_type:)
        expect(user.access_type).to eq(role_type.to_sym)
      end
    end

    context "when the user has multiple DfE roles" do
      it "returns the highest precedence role type" do
        FactoryBot.create(:dfe_role, user:, role_type: "admin")
        FactoryBot.create(:dfe_role, user:, role_type: "super_admin")
        expect(user.access_type).to eq(:super_admin)
      end
    end

    context "when user has appropriate body role" do
      it "returns :appropriate_body" do
        FactoryBot.create(:appropriate_body_role, user:)
        expect(user.access_type).to eq(:appropriate_body)
      end
    end

    context "when user has lead provider role" do
      it "returns :lead_provider" do
        FactoryBot.create(:lead_provider_role, user:)
        expect(user.access_type).to eq(:lead_provider)
      end
    end

    context "when user has delivery partner role" do
      it "returns :delivery_partner" do
        FactoryBot.create(:delivery_partner_role, user:)
        expect(user.access_type).to eq(:delivery_partner)
      end
    end

    context "when user has school role" do
      it "returns :school" do
        FactoryBot.create(:school_role, user:)
        expect(user.access_type).to eq(:school)
      end
    end

    context "when user has no roles" do
      it "returns nil" do
        expect(user.access_type).to be_nil
      end
    end
  end
end
