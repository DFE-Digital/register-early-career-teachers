require "rails_helper"

RSpec.describe Admin::RolesForm, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:appropriate_bodies) { FactoryBot.build_list(:appropriate_body, 3) }
  let(:role_ids) { appropriate_bodies.map(&:id) }
  let(:roles_form) { described_class.new(role_type: "appropriate_body", user:, role_ids:) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(roles_form).to be_valid
    end

    it "is invalid with an invalid role_type" do
      roles_form.role_type = "invalid_role"
      expect(roles_form).not_to be_valid
      expect(roles_form.errors[:role_type]).to include("is not included in the list")
    end
  end

  describe "#collection_for_role_type" do
    it "returns all records for the role type" do
      expect(roles_form.collection_for_role_type).to eq(AppropriateBody.all)
    end
  end

  describe "#save!" do
    let!(:appropriate_bodies) { FactoryBot.create_list(:appropriate_body, 3) }
    let(:role_ids) { [appropriate_bodies.second.id, appropriate_bodies.last.id] }

    it "sets the roles for the user" do
      user.appropriate_body_roles << FactoryBot.create(:appropriate_body_role, user:, appropriate_body: appropriate_bodies.first)

      expect { roles_form.save! }.to change { user.appropriate_bodies.count }.by(1)
      expect(user.appropriate_bodies).to match_array(appropriate_bodies.last(2))
    end
  end
end
