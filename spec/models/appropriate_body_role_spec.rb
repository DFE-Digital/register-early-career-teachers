RSpec.describe AppropriateBodyRole, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:appropriate_body) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:user_id).with_message("Choose a user") }
    it { is_expected.to validate_presence_of(:appropriate_body_id).with_message("Choose an appropriate body") }
  end
end
