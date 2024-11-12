module TRS
  class FakeAPIClient
    def initialize(raise_not_found: false, include_qts: true, prohibited_from_teaching: false)
      @raise_not_found = raise_not_found
      @include_qts = include_qts
      @prohibited_from_teaching = prohibited_from_teaching
    end

    def find_teacher(trn:, date_of_birth:)
      raise(TRS::Errors::TeacherNotFound, "Teacher with TRN #{trn} not found") if @raise_not_found

      Rails.logger.info("TRSFakeAPIClient pretending to find teacher with TRN=#{trn} and Date of birth=#{date_of_birth}")

      TRS::Teacher.new(
        teacher_params(trn:, date_of_birth:)
          .merge(qts)
          .merge(prohibited_from_teaching)
      )
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

    def prohibited_from_teaching
      return {} unless @prohibited_from_teaching

      {
        'alerts' => [{ 'alertType' => { 'alertCategory' => { 'alertCategoryId' => 'b2b19019-b165-47a3-8745-3297ff152581' } } }],
      }
    end
  end
end
