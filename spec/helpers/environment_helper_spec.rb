require 'ostruct'

RSpec.describe EnvironmentHelper, type: :helper do
  include GovukLinkHelper
  include GovukVisuallyHiddenHelper
  include GovukComponentsHelper

  before do
    stub_const('ENVIRONMENT_COLOUR', nil)
    stub_const('ENVIRONMENT_PHASE_BANNER_TAG', nil)
    stub_const('ENVIRONMENT_PHASE_BANNER_CONTENT', nil)
  end

  describe '#environment_specific_header_colour_class' do
    it('is nil when no colour is set (defaults to blue)') do
      expect(environment_specific_header_colour_class).to be(nil)
    end

    context "when ENVIRONMENT_COLOUR is set to 'pink'" do
      it 'returns a pink modifier class' do
        stub_const('ENVIRONMENT_COLOUR', 'pink')
        expect(environment_specific_header_colour_class).to eql("app-header--pink")
      end
    end
  end

  describe '#environment_specific_phase_banner' do
    subject { environment_specific_phase_banner }

    it "is 'Beta' by default" do
      expect(subject).to include("Beta")
    end

    it 'has a govuk tag with no colour modifier' do
      expect(subject).to_not match(/govuk-tag--\w+/)
    end

    it "contains the text 'Give feedback about this service'" do
      expect(subject).to include("Give feedback about this service")
    end

    context 'when ENVIRONMENT_COLOUR, ENVIRONMENT_PHASE_BANNER_CONTENT and ENVIRONMENT_PHASE_BANNER_TAG are set' do
      before do
        stub_const('ENVIRONMENT_COLOUR', 'yellow')
        stub_const('ENVIRONMENT_PHASE_BANNER_TAG', 'Wow')
        stub_const('ENVIRONMENT_PHASE_BANNER_CONTENT', 'What a nice service')
      end

      it 'overwrites the default with the provided value' do
        expect(subject).to include('Wow')
      end

      it 'has a govuk tag with a yellow modifier class' do
        expect(subject).to match(/govuk-tag govuk-tag--yellow govuk-phase-banner__content__tag/)
      end

      it "contains the text 'Give feedback about this service'" do
        expect(subject).to include('What a nice service')
      end
    end
  end
end
