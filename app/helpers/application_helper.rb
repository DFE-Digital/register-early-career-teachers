module ApplicationHelper
  def page_data(title:, header: nil, header_size: "l", error: false)
    page_title = if error
                   "Error: #{title}"
                 else
                   title
                 end

    page_header = tag.h1(header || title, class: "govuk-heading-#{header_size}")

    content_for(:page_title) { page_title }
    content_for(:page_header) { page_header }

    { page_title:, page_header: }
  end
end
