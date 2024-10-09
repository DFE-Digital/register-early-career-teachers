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

    def find_teacher(trn:, date_of_birth:)
      response = @connection.get("/v3/persons/#{trn}", dateOfBirth: date_of_birth)

      if response.success?
        TRS::Teacher.new(JSON.parse(response.body))
      elsif response.status == 404
        raise TRS::Errors::TeacherNotFound, "Teacher with TRN #{trn} not found"
      else
        raise "API request failed: #{response.status} #{response.body}"
      end
    end

    # FIXME: Update this method after the API is implemented
    def begin_induction!(trn:, start_date:)
      Rails.logger.info("TRS API: begin_induction(#{trn}, #{start_date})")
    end

    # FIXME: Update this method after the API is implemented
    def complete_induction!(trn:, completion_date:, status:)
      Rails.logger.info("TRS API: complete_induction(#{trn}, #{completion_date}, #{status})")
    end
  end
end
