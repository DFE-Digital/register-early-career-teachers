class ExampleMailerPreview < ActionMailer::Preview
  def hello_world
    ExampleMailer.with(to: "testbot@example.com", subject: "A nice preview").hello_world
  end
end
