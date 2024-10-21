module Navigation
  class PrimaryNavigationComponent < ViewComponent::Base
    attr_accessor :current_path, :is_authenticated

    def initialize(current_path:, is_authenticated:)
      super
      @is_authenticated = is_authenticated
      @current_path = current_path
    end

    def navigation_items
      [
        (ab_nav_options if current_path.start_with?("/appropriate-body")),
        (school_nav_options if current_path.start_with?("/school")),
        ({ text: "Sign out", href: sign_out_path } if is_authenticated),
      ].flatten.compact
    end

  private

    def school_nav_options
      [
        { text: "Your ECTs", href: schools_ects_home_path },
        { text: "Your mentors", href: 'FIXME' }
      ]
    end

    def ab_nav_options
      []
    end
  end
end
