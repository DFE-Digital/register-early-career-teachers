class ExampleMailer < ApplicationMailer
  def hello_world
    from = params.fetch(:from)
    to = params.fetch(:to)
    subject = params.fetch(:subject)
    @salutation = params.fetch(:salutation)

    @recipient = Data.define(:full_name).new(full_name: "Herbert M Anchovy")

    view_mail(NOTIFY_TEMPLATE_ID, from:, to:, subject:)
  end
end
