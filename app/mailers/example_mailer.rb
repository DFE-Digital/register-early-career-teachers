class ExampleMailer < ApplicationMailer
  def hello_world
    to = params[:to]
    subject = params[:subject]
    @recipient = Data.define(:full_name).new(full_name: "Herbert M Anchovy")

    view_mail(NOTIFY_TEMPLATE_ID, to:, subject:)
  end
end
