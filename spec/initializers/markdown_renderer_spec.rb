require "rails_helper"

RSpec.describe MarkdownRenderer do
  let(:template) { double("template") }
  let(:test_context) do
    Class.new do
      def page_data(title:)
      end

      def self.evaluate_ruby(code)
        new.instance_eval(code)
      end
    end
  end

  before do
    allow(ActionView::Template).to receive(:registered_template_handler).with(:erb).and_return(
      Class.new do
        def self.call(_template, source)
          "\"#{source}\""
        end
      end
    )
  end

  describe ".call" do
    it "renders markdown without frontmatter" do
      source = "# Hello World\n\nThis is a test"
      rendered = test_context.evaluate_ruby(MarkdownRenderer.call(template, source))

      expect(rendered).to include('class="govuk-heading-xl"')
      expect(rendered).to include('Hello World')
      expect(rendered).to include('class="govuk-body-m"')
      expect(rendered).to include('This is a test')
    end

    it "handles frontmatter in markdown" do
      source = <<~MARKDOWN
        ---
        title: Test Title
        ---
        # Content
      MARKDOWN

      expect_any_instance_of(test_context).to receive(:page_data).with(title: "Test Title")
      rendered = test_context.evaluate_ruby(MarkdownRenderer.call(template, source))

      expect(rendered).not_to include("title: Test Title")
      expect(rendered).not_to include("---")
      expect(rendered).to include('class="govuk-heading-xl"')
      expect(rendered).to include('Content')
    end

    it "handles markdown without frontmatter title" do
      source = <<~MARKDOWN
        ---
        other_field: some value
        ---
        # Content
      MARKDOWN

      expect_any_instance_of(test_context).not_to receive(:page_data)
      rendered = test_context.evaluate_ruby(MarkdownRenderer.call(template, source))

      expect(rendered).not_to include("other_field")
      expect(rendered).not_to include("---")
      expect(rendered).to include('class="govuk-heading-xl"')
      expect(rendered).to include('Content')
    end

    it "handles invalid frontmatter gracefully" do
      source = <<~MARKDOWN
        ---
        invalid yaml content
        ---
        # Content
      MARKDOWN

      rendered = test_context.evaluate_ruby(MarkdownRenderer.call(template, source))

      expect(rendered).not_to include("invalid yaml content")
      expect(rendered).not_to include("---")
      expect(rendered).to include('class="govuk-heading-xl"')
      expect(rendered).to include('Content')
    end
  end
end
