require 'rails_helper'

describe Admin::Access do
  subject { Admin::Access.new(user) }

  context 'when the user has a DfE role' do
    let!(:user) { FactoryBot.create(:user, :admin) }

    it 'allows access' do
      expect(subject.can_access?).to be(true)
    end
  end

  context 'when the user has no DfE role' do
    let!(:user) { FactoryBot.create(:user) }

    it "doesn't allow access" do
      expect(subject.can_access?).to be(false)
    end
  end
end
