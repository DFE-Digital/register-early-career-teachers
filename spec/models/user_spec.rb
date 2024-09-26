describe User do
  subject(:user) { FactoryBot.build(:user) }

  describe 'validation' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:appropriate_body_roles) }
    it { is_expected.to have_many(:appropriate_bodies).through(:appropriate_body_roles) }
    it { is_expected.to have_many(:dfe_roles) }
  end
end
