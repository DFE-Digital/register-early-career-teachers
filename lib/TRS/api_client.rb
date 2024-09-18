module TRS
  class APIClient
    def initialize
      @connection = Faraday.new(url: ENV['TRS_BASE_URL']) do |faraday|
        faraday.headers['Authorization'] = "Bearer #{ENV['TRS_API_KEY']}"
        faraday.headers['Accept'] = 'application/json'
        faraday.headers['X-Api-Version'] = '20240814'
        faraday.adapter Faraday.default_adapter
      end
    end

    def find_teacher(trn:, date_of_birth: nil)
      response = @connection.get("/v3/persons/#{trn}", dateOfBirth: date_of_birth)

      if response.success?
        TRS::Teacher.new(JSON.parse(response.body))
      elsif response.status == 404
        nil
      else
        raise "API request failed: #{response.status} #{response.body}"
      end
    end
  end
end
