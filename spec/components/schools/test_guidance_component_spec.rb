require "rails_helper"

describe Schools::TestGuidanceComponent, type: :component do
  it "renders when TEST_GUIDANCE is true" do
    with_env_var("TEST_GUIDANCE", "true") do
      render_inline(described_class.new)
      expect(rendered_content).to include("Information to review this journey")
    end
  end

  it "does not render when TEST_GUIDANCE is false" do
    with_env_var("TEST_GUIDANCE", "false") do
      render_inline(described_class.new)
      expect(rendered_content).not_to include("Information to review this journey")
    end
  end

  it "does not render when TEST_GUIDANCE is missing" do
    with_env_var("TEST_GUIDANCE", nil) do
      render_inline(described_class.new)
      expect(rendered_content).not_to include("Information to review this journey")
    end
  end

  def with_env_var(key, value)
    allow(ENV).to receive(:fetch).with(key, false).and_return(value)
    yield
  end
end
