require 'rails_helper'
require 'ostruct'

RSpec.describe EnvironmentHelper, type: :helper do
  include GovukLinkHelper
  include GovukVisuallyHiddenHelper
  include GovukComponentsHelper

  describe "#environment_specific_header_colour_class" do
    subject { environment_specific_header_colour_class(environment:) }

    context("when production") do
      let(:environment) { "production" }

      it { is_expected.to be_nil }
    end

    context("when test") do
      let(:environment) { "test" }

      it { is_expected.to be_nil }
    end

    %w[development staging sandbox review].each do |environment|
      context("when #{environment}") do
        let(:environment) { environment }

        it { is_expected.to eql("app-header--#{environment}") }
      end
    end
  end

  describe "#environment_specific_phase_banner" do
    subject { environment_specific_phase_banner(environment:) }

    context("when production") do
      let(:environment) { "production" }

      it { is_expected.to include("Give feedback about this service") }
      it { is_expected.to_not match(/govuk-tag--\w+/) }
    end

    context("when test") do
      let(:environment) { "production" }

      it { is_expected.to include("Give feedback about this service") }
      it { is_expected.to_not match(/govuk-tag--\w+/) }
    end

    [
      OpenStruct.new(environment: "development", colour: "pink", text: "The application is running in development mode"),
      OpenStruct.new(environment: "review", colour: "orange", text: "This is a review application, not a real service"),
      OpenStruct.new(environment: "staging", colour: "purple", text: "This is a staging environment"),
      OpenStruct.new(environment: "sandbox", colour: "yellow", text: "This is a sandbox environment")
    ].each do |expectation|
      context("when #{expectation.environment}") do
        let(:environment) { expectation.environment }

        it { is_expected.to include(expectation.text) }
        it { is_expected.to match(/govuk-tag--\w+/) }
        it { is_expected.to match(/govuk-tag--#{expectation.colour}/) }
      end
    end
  end
end
