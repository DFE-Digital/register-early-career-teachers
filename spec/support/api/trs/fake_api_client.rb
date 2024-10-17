module TRS
  class FakeAPIClient
    def initialize(raise_not_found: false, include_qts: true)
      @raise_not_found = raise_not_found
      @include_qts = include_qts
    end

    def find_teacher(trn:, date_of_birth:)
      raise(TRS::Errors::TeacherNotFound, "Teacher with TRN #{trn} not found") if @raise_not_found

      Rails.logger.info("TRSFakeAPIClient pretending to find teacher with TRN=#{trn} and Date of birth=#{date_of_birth}")

      TRS::Teacher.new(teacher_params(trn:, date_of_birth:).merge(qts))
    end

  private

    def teacher_params(trn:, date_of_birth:)
      {
        'trn' => trn,
        'firstName' => 'Kirk',
        'lastName' => 'Van Houten',
        'dateOfBirth' => date_of_birth,
      }
    end

    def qts
      return {} unless @include_qts

      {
        'qts' => {
          'awarded' => Time.zone.today - 3.years,
          'certificateUrl' => 'string',
          'statusDescription' => 'string'
        }
      }
    end
  end
end
