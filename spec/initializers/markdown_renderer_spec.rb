require "rails_helper"

RSpec.describe MarkdownRenderer do
  let(:template) { double("template") }
  let(:erb_handler) { double("erb_handler") }

  before do
    allow(ActionView::Template).to receive(:registered_template_handler).with(:erb).and_return(erb_handler)
  end

  describe ".call" do
    it "returns Ruby code string for markdown without frontmatter" do
      source = "# Hello World\n\nThis is a test"
      allow(erb_handler).to receive(:call).with(template, source).and_return('"processed markdown"')

      rendered = MarkdownRenderer.call(template, source)
      expect(rendered).to eq(
        <<~RUBY
          page_data_from_front_matter(begin; nil; end)
          MarkdownRenderer.render(begin; "processed markdown"; end)
        RUBY
      )
    end

    it "processes ERB in both frontmatter and content" do
      source = <<~MARKDOWN
        ---
        title: <%= @page_title %>
        author: <%= current_user.name %>
        ---
        # <%= @heading %>
      MARKDOWN

      # Expect ERB processing for both front matter and content
      allow(erb_handler).to receive(:call)
        .with(template, "\ntitle: <%= @page_title %>\nauthor: <%= current_user.name %>\n")
        .and_return('"processed frontmatter"')

      allow(erb_handler).to receive(:call)
        .with(template, "# <%= @heading %>\n")
        .and_return('"processed content"')

      rendered = MarkdownRenderer.call(template, source)
      expect(rendered).to eq(
        <<~RUBY
          page_data_from_front_matter(begin; "processed frontmatter"; end)
          MarkdownRenderer.render(begin; "processed content"; end)
        RUBY
      )
    end

    it "handles markdown with invalid frontmatter while still processing ERB" do
      source = <<~MARKDOWN
        ---
        invalid: <%= @yaml %> content
        ---
        # Content
      MARKDOWN

      allow(erb_handler).to receive(:call)
        .with(template, "\ninvalid: <%= @yaml %> content\n")
        .and_return('"processed invalid frontmatter"')

      allow(erb_handler).to receive(:call)
        .with(template, "# Content\n")
        .and_return('"processed content"')

      rendered = MarkdownRenderer.call(template, source)
      expect(rendered).to eq(
        <<~RUBY
          page_data_from_front_matter(begin; "processed invalid frontmatter"; end)
          MarkdownRenderer.render(begin; "processed content"; end)
        RUBY
      )
    end

    it "processes ERB in content when no frontmatter is present" do
      source = "# <%= @title %>\n\nThis is a <%= @type %> test"
      allow(erb_handler).to receive(:call)
        .with(template, source)
        .and_return('"processed content with variables"')

      rendered = MarkdownRenderer.call(template, source)
      expect(rendered).to eq(
        <<~RUBY
          page_data_from_front_matter(begin; nil; end)
          MarkdownRenderer.render(begin; "processed content with variables"; end)
        RUBY
      )
    end
  end
end
