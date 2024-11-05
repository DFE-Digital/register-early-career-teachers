module MarkdownRenderer
  def self.call(template, source)
    erb_handler = ActionView::Template.registered_template_handler(:erb)
    compiled_source = erb_handler.call(template, source)

    <<-RUBY
      source = #{compiled_source}.to_str
      front_matter_match = source.match(/\\A(---\\s*\\n.*?\\n?)^(---\\s*$\\n?)/m)
      if front_matter_match
        front_matter = front_matter_match[1]
        source = source.sub(front_matter_match[0], '')
        title_match = front_matter.match(/title:\\s*(.*)/)

        if title_match and title_match[1].present?
          page_data(title: title_match[1])
        end

      end
      source.strip!
      GovukMarkdown.render(source).html_safe
    RUBY
  end
end

ActionView::Template.register_template_handler :md, MarkdownRenderer
ActionView::Template.register_template_handler :"md.erb", MarkdownRenderer
