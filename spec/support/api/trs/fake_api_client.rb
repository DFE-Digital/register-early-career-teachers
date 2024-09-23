module TRS
  class FakeAPIClient
    def find_teacher(trn:, date_of_birth:)
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
