require "rails_helper"

RSpec.describe MarkdownRenderer do
  let(:template) { double("template") }
  let(:erb_handler) { double("erb_handler") }

  before do
    allow(ActionView::Template).to receive(:registered_template_handler).with(:erb).and_return(erb_handler)
    allow(erb_handler).to receive(:call).and_return('"processed markdown"')
  end

  describe ".call" do
    it "returns Ruby code string for markdown without frontmatter" do
      source = "# Hello World\n\nThis is a test"
      rendered = MarkdownRenderer.call(template, source)
      expect(rendered).to eq(
        <<~RUBY
          page_data_from_front_matter('')
          MarkdownRenderer.render(begin; "processed markdown"; end)
        RUBY
      )
    end

    it "returns Ruby code string for markdown with frontmatter" do
      source = <<~MARKDOWN
        ---
        title: Test Title
        ---
        # Content
      MARKDOWN

      rendered = MarkdownRenderer.call(template, source)
      expect(rendered).to eq(
        <<~RUBY
          page_data_from_front_matter('
          title: Test Title
          ')
          MarkdownRenderer.render(begin; "processed markdown"; end)
        RUBY
      )
    end

    it "returns Ruby code string for markdown with invalid frontmatter" do
      source = <<~MARKDOWN
        ---
        invalid yaml content
        ---
        # Content
      MARKDOWN

      rendered = MarkdownRenderer.call(template, source)

      expect(rendered).to eq(
        <<~RUBY
          page_data_from_front_matter('
          invalid yaml content
          ')
          MarkdownRenderer.render(begin; "processed markdown"; end)
        RUBY
      )
    end
  end
end
