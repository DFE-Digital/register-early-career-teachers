module Navigation
  module Structures
    class BaseSubNavigation
      include Rails.application.routes.url_helpers

      # A Node is an entry in a navigation list, it contains:
      #
      # * name    - the hyperlink text which appears in the list
      # * href    - the hyperlink href
      # * prefix  - the beginning of a path which will trigger the node to be marked
      #            'current' and highlighted in the nav
      # * current - a boolean value where the result of the prefix match is stored,
      #             this isn't done on the fly so we can pass the value along from
      #             the primary nav to the sub nav
      # * nodes   - a list of nodes that sit under this one in the structure
      Node = Struct.new(:name, :href, :prefix, :nodes)
    end
  end
end
