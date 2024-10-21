require "rails_helper"

RSpec.describe Navigation::PrimaryNavigationComponent, type: :component do
  describe "a nested navigation structure with two levels" do
    let(:is_authenticated) { true }

    subject { described_class.new(current_path:, is_authenticated:) }

    def validate_navigation_options(options)
      options.each do |option|
        expect(rendered_content).to have_css("a.govuk-service-navigation__link", text: option[:text])
        expect(rendered_content).to have_css("a.govuk-service-navigation__link[href='#{option[:href]}']")
      end
    end

    context "when AB path" do
      let(:current_path) { "/appropriate-body/1" }

      let(:expected_school_nav_options) do
        [{ text: "Sign out", href: "/sign-out" }]
      end

      it "renders AB path options" do
        render_inline(subject)

        validate_navigation_options(expected_school_nav_options)
      end

      context "when not authenticated" do
        let(:is_authenticated) { false }

        it "does not render the sign out option" do
          render_inline(subject)

          expect(rendered_content).not_to have_css("a.govuk-service-navigation__link", text: "Sign out")
        end
      end
    end

    context "when school path" do
      let(:current_path) { "/schools/home/ects" }
      let(:expected_school_nav_options) do
        [
          { text: "Your ECTs", href: "/schools/home/ects" },
          { text: "Your mentors", href: 'FIXME' },
          { text: "Sign out", href: "/sign-out" }
        ]
      end

      it "renders school path options" do
        render_inline(subject)

        validate_navigation_options(expected_school_nav_options)
      end

      context "when not authenticated" do
        let(:is_authenticated) { false }

        it "does not render the sign out option" do
          render_inline(subject)

          expect(rendered_content).not_to have_css("a.govuk-service-navigation__link", text: "Sign out")
        end
      end
    end

    context "when any other path" do
      let(:current_path) { "/" }
      let(:expected_school_nav_options) do
        [{ text: "Sign out", href: "/sign-out" }]
      end

      it "renders just the sign out option" do
        render_inline(subject)

        validate_navigation_options(expected_school_nav_options)
      end

      context "when not authenticated" do
        let(:is_authenticated) { false }

        it "does not render the sign out option" do
          render_inline(subject)

          expect(rendered_content).not_to have_css("a.govuk-service-navigation__link", text: "Sign out")
        end
      end
    end
  end
end
