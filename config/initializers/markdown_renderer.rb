module MarkdownRenderer
  def self.call(template, source)
    erb_handler = ActionView::Template.registered_template_handler(:erb)
    page_sections = source.match(/^\s*---(?<front_matter>.*?)---\s(?<markdown>.*)/m)

    if page_sections
      front_matter = erb_handler.call(template, page_sections[:front_matter])
      page_content = erb_handler.call(template, page_sections[:markdown])
    else
      page_content = erb_handler.call(template, source)
      front_matter = 'nil'
    end

    <<~RUBY
      page_data_from_front_matter(begin; #{front_matter}; end)
      MarkdownRenderer.render(begin; #{page_content}; end)
    RUBY
  end

  def self.render(markdown)
    GovukMarkdown.render(markdown.to_str).html_safe
  end
end

ActionView::Template.register_template_handler :md, MarkdownRenderer
ActionView::Template.register_template_handler :"md.erb", MarkdownRenderer
