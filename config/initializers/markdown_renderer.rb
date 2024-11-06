module MarkdownRenderer
  def self.call(template, source)
    erb_handler = ActionView::Template.registered_template_handler(:erb)
    page_sections = source.match(/^\s*---(?<front_matter>.*?)---\s(?<markdown>.*)/m)
    front_matter = page_sections[:front_matter] if page_sections
    page_content = page_sections ? page_sections[:markdown] : source
    compiled_source = erb_handler.call(template, page_content)

    <<~RUBY
      page_data_from_front_matter('#{front_matter}')
      MarkdownRenderer.render(begin; #{compiled_source}; end)
    RUBY
  end

  def self.render(markdown)
    GovukMarkdown.render(markdown.to_str).html_safe
  end
end

ActionView::Template.register_template_handler :md, MarkdownRenderer
ActionView::Template.register_template_handler :"md.erb", MarkdownRenderer
