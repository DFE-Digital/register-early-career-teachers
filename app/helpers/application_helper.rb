module ApplicationHelper
  def page_data(title:, header: nil, header_size: "l", error: false, backlink_href: nil)
    page_title = if error
                   "Error: #{title}"
                 else
                   title
                 end

    content_for(:page_title) { page_title }

    return { page_title: } if header == false

    backlink_or_breadcrumb = govuk_back_link(href: backlink_href) unless backlink_href.nil?

    content_for(:backlink_or_breadcrumb) { backlink_or_breadcrumb }

    page_header = tag.h1(header || title, class: "govuk-heading-#{header_size}")

    content_for(:page_header) { page_header }

    { page_title:, backlink_or_breadcrumb:, page_header: }
  end
end
