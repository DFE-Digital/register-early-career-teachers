require "rails_helper"

describe Schools::TestGuidanceComponent, type: :component do
  it "renders when TEST_GUIDANCE is true" do
    with_env_var("TEST_GUIDANCE", "true") do
      render_inline(described_class.new) { "some content" }
      expect(rendered_content).to include("some content")
    end
  end

  it "does not render when TEST_GUIDANCE is false" do
    with_env_var("TEST_GUIDANCE", "false") do
      render_inline(described_class.new)
      expect(rendered_content).to be_blank
    end
  end

  it "does not render when TEST_GUIDANCE is missing" do
    with_env_var("TEST_GUIDANCE", nil) do
      render_inline(described_class.new)
      expect(rendered_content).to be_blank
    end
  end

  describe 'TRS example details' do
    it 'contains a table with TRNs and dates of birth' do
      with_env_var("TEST_GUIDANCE", "true") do
        render_inline(described_class.new) do |component|
          component.with_trs_example_teacher_details
        end

        expect(rendered_content).to include('Information to review this journey')
      end
    end
  end

  def with_env_var(key, value)
    allow(ENV).to receive(:fetch).with(key, false).and_return(value)
    yield
  end
end
