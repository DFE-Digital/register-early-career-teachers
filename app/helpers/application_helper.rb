module ApplicationHelper
  def page_data(title:, header: nil, header_size: "l", error: false)
    page_title = if error
                   "Error: #{title}"
                 else
                   title
                 end

    content_for(:page_title) { page_title }

    return { page_title: } if header == false

    page_header = tag.h1(header || title, class: "govuk-heading-#{header_size}")

    content_for(:page_header) { page_header }

    { page_title:, page_header: }
  end

  def service_navigation_items(service_navigation, context: :admin)
    case context
    when :admin
      service_navigation.with_navigation_item(text: "Migration", href: admin_migration_teachers_path)
    end
  end
end
