module Navigation
  class PrimaryNavigationComponent < ViewComponent::Base
    attr_accessor :current_path, :is_authenticated

    def initialize(current_path:, is_authenticated:)
      super
      @is_authenticated = is_authenticated
      @current_path = current_path
    end

    def call
      govuk_service_navigation(service_name: "Register early career teachers") do |service_navigation|
        navigation_items.each do |item|
          service_navigation.with_navigation_item(
            text: item[:text],
            href: item[:href],
            current: current_page?(item[:href])
          )
        end
      end
    end

  private

    def navigation_items
      [
        ab_nav_options,
        school_nav_options,
        ({ text: "Sign out", href: sign_out_path } if is_authenticated),
      ].flatten.compact
    end

    def school_nav_options
      if current_path.start_with?("/school")
        [
          { text: "Your ECTs", href: schools_ects_home_path },
          { text: "Your mentors", href: 'FIXME' }
        ]
      end
    end

    def ab_nav_options
      if current_path.start_with?("/appropriate-body")
        []
      end
    end
  end
end
