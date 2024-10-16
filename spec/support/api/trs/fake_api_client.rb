module TRS
  class FakeAPIClient
    def initialize(raise_not_found: false, nullify_qts: false)
      @raise_not_found = raise_not_found
      @nullify_qts = nullify_qts
    end

    def find_teacher(trn:, date_of_birth:)
      raise(TRS::Errors::TeacherNotFound, "Teacher with TRN #{trn} not found") if @raise_not_found

      Rails.logger.info("TRSFakeAPIClient pretending to find teacher with TRN=#{trn} and Date of birth=#{date_of_birth}")

      @trn = trn
      @date_of_birth = date_of_birth

      teacher_params = {
        'trn' => trn,
        'firstName' => 'Kirk',
        'lastName' => 'Van Houten',
        'dateOfBirth' => date_of_birth,
        'qts' => {
          'awarded' => Time.zone.today - 3.years,
          'certificateUrl' => 'string',
          'statusDescription' => 'string'
        },
      }

      teacher_params = teacher_params.delete('qts') if @nullify_qts

      TRS::Teacher.new(teacher_params)
    end
  end
end
