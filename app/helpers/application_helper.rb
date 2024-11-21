module ApplicationHelper
  include Pagy::Frontend

  def page_data(title:, header: nil, header_size: "l", error: false, backlink_href: nil, caption: nil, caption_size: 'm')
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

    page_caption = tag.span(caption, class: "govuk-caption-#{caption_size}")

    content_for(:page_caption) { page_caption } unless caption.nil?

    { page_title:, backlink_or_breadcrumb:, page_header:, page_caption: }
  end

  def page_data_from_front_matter(yaml)
    parsed_yaml = YAML.load(yaml)&.symbolize_keys

    return unless parsed_yaml

    page_data(**parsed_yaml)
  end

  def support_mailto_link
    address = 'continuing-professional-development@digital.education.gov.uk'

    govuk_link_to(address, 'mailto:' + address)
  end
end
