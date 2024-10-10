RSpec.describe SessionsHelper, type: :helper do
  include GovukLinkHelper
  include GovukVisuallyHiddenHelper

  describe '#login_options' do
    let(:one_time_password_link_text) { 'Sign-in with a one time password' }
    let(:persona_link_text) { 'Sign-in with a persona' }

    context 'when personas are enabled (ENABLE_PERSONAS=true)' do
      before { allow(Rails.application.config).to receive(:enable_personas).and_return(true) }

      it 'includes one time password' do
        expect(login_options).to have_css('a', text: one_time_password_link_text)
      end

      it 'includes one time persona' do
        expect(login_options).to have_css('a', text: persona_link_text)
      end
    end

    context 'when personas are enabled (ENABLE_PERSONAS=false)' do
      before { allow(Rails.application.config).to receive(:enable_personas).and_return(false) }

      it 'includes one time password' do
        expect(login_options).to have_css('a', text: one_time_password_link_text)
      end

      it 'does not include one time persona' do
        expect(login_options).not_to have_css('a', text: persona_link_text)
      end
    end
  end
end
