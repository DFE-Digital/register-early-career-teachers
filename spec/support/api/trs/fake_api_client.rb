module TRS
  class FakeAPIClient
    def initialize(raise_not_found: false)
      @raise_not_found = raise_not_found
    end

    def find_teacher(trn:, date_of_birth:)
      raise(TRS::Errors::TeacherNotFound, "Teacher with TRN #{trn} not found") if @raise_not_found

      Rails.logger.info("TRSFakeAPIClient pretending to find teacher with TRN=#{trn} and Date of birth=#{date_of_birth}")

      @trn = trn
      @date_of_birth = date_of_birth

      TRS::Teacher.new({
        'trn' => trn,
        'firstName' => 'Kirk',
        'lastName' => 'Van Houten',
        'dateOfBirth' => date_of_birth,
      })
    end
  end
end
