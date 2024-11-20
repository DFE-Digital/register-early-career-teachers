module MarkdownRenderer
  def self.call(template, source)
    erb_handler = ActionView::Template.registered_template_handler(:erb)

    if (page_sections = source.match(/^\s*---(?<front_matter>.*?)---\s(?<markdown>.*)/m))
      front_matter = erb_handler.call(template, page_sections[:front_matter])
      page_content = erb_handler.call(template, page_sections[:markdown])

      # Flush the @output_buffer between retrieving front_matter and
      # rendering the rest of the page so we don't render the front_matter
      # unintentionally
      <<~RUBY
        page_data_from_front_matter(begin; #{front_matter}; end)

        @output_buffer = ActionView::OutputBuffer.new;

        MarkdownRenderer.render(begin; #{page_content}; end)
      RUBY
    else
      page_content = erb_handler.call(template, source)

      "MarkdownRenderer.render(begin; #{page_content}; end)"
    end
  end

  def self.render(markdown)
    GovukMarkdown.render(markdown.to_str, { strip_front_matter: true }).html_safe
  end
end

ActionView::Template.register_template_handler :md, MarkdownRenderer
ActionView::Template.register_template_handler :"md.erb", MarkdownRenderer
