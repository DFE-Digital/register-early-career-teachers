# frozen_string_literal: true

require "zip"

module GIAS
  class APIClient
    def get_files
      data = fetch_extract
      temp_files_from_zipped_response(data)
    end

  private

    def fetch_extract
      client = Savon.client(wsdl: ENV["GIAS_API_SCHEMA"])
      res = client.call(
        :get_extract,
        message: { "tns:Id" => ENV["GIAS_EXTRACT_ID"] },
        wsse_auth: [ENV["GIAS_API_USER"], ENV["GIAS_API_PASSWORD"]],
        wsse_timestamp: true,
      )
      parts = parse_body(res.http)
      parts.second.body.to_s
    end

    def temp_files_from_zipped_response(data)
      files = {}

      # We need to write the zip file to disk rather than read it from a buffer because of this:
      # https://github.com/rubyzip/rubyzip#notice-about-zipinputstream
      zipfile = Tempfile.new(encoding: "ASCII-8BIT")
      zipfile.write(data.force_encoding("ASCII-8BIT"))
      zipfile.close
      Zip::File.open(zipfile) do |zip_contents|
        zip_contents.each do |file|
          tempfile = Tempfile.new(encoding: "UTF-8")
          tempfile.write(file.get_input_stream.read.force_encoding("UTF-8"))
          tempfile.close

          files[file.name] = tempfile
        end
      end

      files
    end

    def parse_body(http)
      Mail::Part.new(
        headers: http.headers,
        body: http.body,
      ).body.split!(boundary(http)).parts
    end

    def boundary(http)
      Mail::Field.new("content-type", http.headers["content-type"]).parameters["boundary"]
    end
  end
end
