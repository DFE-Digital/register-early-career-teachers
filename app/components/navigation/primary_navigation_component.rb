module Navigation
  class PrimaryNavigationComponent < ViewComponent::Base
    attr_accessor :current_path, :current_user

    def initialize(current_path:, current_user:)
      super
      @current_user = current_user
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

    def ab_nav_options
      if current_path.start_with?("/appropriate-body")
        []
      end
    end

    def dfe_nav_options
      if Admin::Access.new(current_user).can_access?
        [
          { text: "Schools", href: admin_schools_path },
        ]
      end
    end

    def navigation_items
      [
        ab_nav_options,
        dfe_nav_options,
        school_nav_options,
        ({ text: "Sign out", href: sign_out_path } if current_user),
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
  end
end
