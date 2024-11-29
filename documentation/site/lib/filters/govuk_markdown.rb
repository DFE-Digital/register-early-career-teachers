require 'govuk_markdown'
require 'debug'

Nanoc::Filter.define(:govuk_markdown) do |content, _params|
  GovukMarkdown.render(content, { headings_start_with: "l" })
end
