require "rails_helper"

class TestSubNavigationStructureTwoLevels < Navigation::Structures::BaseSubNavigation
  def get
    [
      Node.new(
        name: "This is the Sub Nav 1 page",
        href: "/sub-nav-1",
        prefix: "/sub-nav-1",
        nodes: [
          Node.new(
            name: "This is the Sub Nav 1.1 page",
            href: "/sub-nav-1.1",
            prefix: "/sub-nav-1.1"
          ),
        ]
      ),
      Node.new(
        name: "This is the Sub Nav 2 page",
        href: "/sub-nav-2",
        prefix: "/sub-nav-2",
        nodes: [
          Node.new(
            name: "This is the Sub Nav 2.1 page",
            href: '/sub-nav-2.1',
            prefix: "/sub-nav-2.1"
          ),
        ]
      ),
    ]
  end
end

class TestSubNavigationStructureOneLevel < Navigation::Structures::BaseSubNavigation
  def get
    [
      Node.new(
        name: "This is the Sub Nav 1 page",
        href: '/sub-nav-1',
        prefix: "/sub-nav-1"
      )
    ]
  end
end

RSpec.describe Navigation::SubNavigationComponent, type: :component do
  describe "a nested navigation structure with two levels" do
    let(:current_path) { "/some-path" }
    let(:structure) { TestSubNavigationStructureTwoLevels.new }

    subject do
      Navigation::SubNavigationComponent.new(current_path, structure: structure.get)
    end

    it "renders a visually hidden h2 heading" do
      render_inline(subject)

      expect(rendered_content).to have_css("h2.govuk-visually-hidden", text: "Navigation")
    end

    it "renders top level navigation items" do
      render_inline(subject)

      selector = "li.x-govuk-sub-navigation__section-item > a.x-govuk-sub-navigation__link"

      expect(rendered_content).to have_css(selector, text: "This is the Sub Nav 1 page")
      expect(rendered_content).to have_css(selector, text: "This is the Sub Nav 2 page")
    end

    it "renders second level navigation items" do
      render_inline(subject)

      selector = %w[
        li.x-govuk-sub-navigation__section-item
        ul.x-govuk-sub-navigation__section--nested
        li.x-govuk-sub-navigation__section-item
        a.x-govuk-sub-navigation__link
      ].join(" > ")

      expect(rendered_content).to have_css(selector, text: "This is the Sub Nav 1.1 page")
      expect(rendered_content).to have_css(selector, text: "This is the Sub Nav 2.1 page")
    end
  end

  describe "a navigation structure with only one level" do
    let(:structure) { TestSubNavigationStructureOneLevel.new }
    let(:current_path) { "/some-path" }

    subject do
      Navigation::SubNavigationComponent.new(current_path, structure: structure.get)
    end

    it "renders top level navigation items" do
      render_inline(subject)

      selector = "li.x-govuk-sub-navigation__section-item > a.x-govuk-sub-navigation__link"

      expect(rendered_content).to have_css(selector, text: "This is the Sub Nav 1 page")
    end
  end

  describe "highlighting the current top level nav item" do
    context "when the prefix matches the start of the current path" do
      let(:current_path) { "/sub-nav-1" }
      let(:structure) { TestSubNavigationStructureTwoLevels.new }

      subject do
        Navigation::SubNavigationComponent.new(current_path, structure: structure.get)
      end

      it "marks only the nav item with the matching prefix as 'current'" do
        render_inline(subject)

        selector = "li.x-govuk-sub-navigation__section-item--current"

        expect(rendered_content).to have_css(selector, text: "This is the Sub Nav 1 page")
        expect(rendered_content).to have_css(selector, count: 1)
      end
    end
  end

  describe "highlighting the current second level nav item" do
    context "when the prefix matches the start of the current path" do
      let(:current_path) { "/sub-nav-1.1" }
      let(:structure) { TestSubNavigationStructureTwoLevels.new }

      subject do
        Navigation::SubNavigationComponent.new(current_path, structure: structure.get)
      end

      it "marks only the section as current" do
        render_inline(subject)

        selector = %w[
          li.x-govuk-sub-navigation__section-item
          ul.x-govuk-sub-navigation__section--nested
          li.x-govuk-sub-navigation__section-item
          a.x-govuk-sub-navigation__link[aria-current="true"]
        ].join(" > ")

        expect(rendered_content).to have_css(selector, text: "This is the Sub Nav 1.1 page")
        expect(rendered_content).to have_css(selector, count: 1)
      end
    end
  end
end
