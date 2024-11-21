RSpec.describe ApplicationHelper, type: :helper do
  include GovukVisuallyHiddenHelper
  include GovukLinkHelper
  describe "#page_data" do
    it "sets the title to the provided value" do
      expect(page_data(title: "Some title").fetch(:page_title)).to eq('Some title')
    end

    it "prefixes title with 'Error:' when there's an error present" do
      expect(page_data(title: "Some title", error: true).fetch(:page_title)).to eq('Error: Some title')
    end

    it "wraps the header in a h1 with govuk-heading-l" do
      expect(page_data(title: "Some title", header: "Some header").fetch(:page_header)).to eq(%(<h1 class="govuk-heading-l">Some header</h1>))
    end

    context "when no header is provided" do
      it "sets the header to the title value" do
        expect(page_data(title: "Some title").fetch(:page_header)).to eq(%(<h1 class="govuk-heading-l">Some title</h1>))
      end
    end

    it "allows the title size to be overridden" do
      expect(page_data(title: "Some title", header: "Some header", header_size: "m").fetch(:page_header)).to eq(%(<h1 class="govuk-heading-m">Some header</h1>))
    end

    it 'sets the heading caption to the provided value with the default size m' do
      expect(page_data(title: "Some title", caption: 'Some caption').fetch(:page_caption)).to eq('<span class="govuk-caption-m">Some caption</span>')
    end

    context 'when the caption size is overridden' do
      it 'sets the heading caption to the provided value with the provided size' do
        expect(page_data(title: "Some title", caption: 'Some caption', caption_size: 'l').fetch(:page_caption)).to eq('<span class="govuk-caption-l">Some caption</span>')
      end
    end
  end

  describe "#page_data_from_front_matter" do
    context "with yaml content" do
      let(:front_matter) do
        <<~FRONT_MATTER
          ---
          title: Some title
          header: Some header
          ---
          ignored content
        FRONT_MATTER
      end

      it "calls page_data with the provided front matter content" do
        allow(self).to receive(:page_data)

        page_data_from_front_matter(front_matter)

        expect(self).to have_received(:page_data).with(title: "Some title", header: "Some header")
      end
    end

    context "handles empty content" do
      let(:front_matter) { "" }

      it "returns nil" do
        allow(self).to receive(:page_data)

        page_data_from_front_matter(front_matter)

        expect(self).not_to have_received(:page_data)
      end
    end
  end

  describe '#support_mailto_link' do
    it 'returns a govuk styled link to the CPD support email address' do
      expect(support_mailto_link).to have_css(
        %(a[href='mailto:continuing-professional-development@digital.education.gov.uk'][class='govuk-link']),
        text: 'continuing-professional-development@digital.education.gov.uk'
      )
    end
  end
end
