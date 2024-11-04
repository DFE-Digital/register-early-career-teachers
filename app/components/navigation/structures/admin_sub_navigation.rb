module Navigation
  module Structures
    class AdminSubNavigation < Navigation::Structures::BaseSubNavigation
      def get
        [
          Node.new(
            name: "Admin",
            href: "#",
            prefix: "/admin",
            nodes: [
              Node.new(
                name: "Teachers",
                href: admin_teachers_path,
                prefix: "/admin/1.1"
              ),
              Node.new(
                name: "Admin 1.2",
                href: '#',
                prefix: "/admin/1.2"
              )
            ]
          ),
          Node.new(
            name: "Sub Nav 2",
            href: '#',
            prefix: "/sub-nav-2",
            nodes: [
              Node.new(
                name: "Sub Nav 2.1",
                href: '#',
                prefix: "/sub-nav-2.1"
              ),
            ]
          ),
          Node.new(
            name: "Sub Nav 3",
            href: '#',
            prefix: "/sub-nav-3",
            nodes: [
              Node.new(
                name: "Sub Nav 3.1",
                href: '#',
                prefix: "/sub-nav-3.1"
              ),
            ]
          ),
        ]
      end
    end
  end
end
