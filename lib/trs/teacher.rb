module TRS
  class Teacher
    PROHIBITED_FROM_TEACHING_CATEGORY_ID = 'b2b19019-b165-47a3-8745-3297ff152581'.freeze
    INVALID_INDUCTION_STATUSES = %w[Exempt Pass Fail PassedinWales FailedinWales].freeze

    attr_reader :trn, :first_name, :last_name, :date_of_birth, :induction_status

    def initialize(data)
      @trn = data['trn']
      @first_name = data['firstName']
      @last_name = data['lastName']
      @date_of_birth = data['dateOfBirth']
      @email_address = data['emailAddress']
      @national_insurance_number = data['nationalInsuranceNumber']

      @alerts = data['alerts']
      @induction_start_date = data.dig('induction', 'startDate')
      @induction_status = data.dig('induction', 'status')

      @qts_awarded = data.dig('qts', 'awarded')
      @qts_status_description = data.dig('qts', 'statusDescription')

      @induction_status_description = data.dig('induction', 'statusDescription')

      @initial_teacher_training_provider_name = data.dig('initialTeacherTraining', -1, 'provider', 'name')
      @initial_teacher_training_end_date = data.dig('initialTeacherTraining', -1, 'endDate')
    end

    def present
      {
        trn: @trn,
        date_of_birth: @date_of_birth,
        trs_national_insurance_number: @national_insurance_number,
        trs_first_name: @first_name,
        trs_last_name: @last_name,
        trs_email_address: @email_address,
        trs_alerts: @alerts,
        trs_induction_start_date: @induction_start_date,
        trs_induction_status: @induction_status,
        trs_induction_status_description: @induction_status_description,
        trs_initial_teacher_training_provider_name: @initial_teacher_training_provider_name,
        trs_initial_teacher_training_end_date: @initial_teacher_training_end_date,
        trs_qts_awarded: @qts_awarded,
        trs_qts_status_description: @qts_status_description,
      }
    end

    def begin_induction!(start_date)
      api_client.begin_induction!(trn:, start_date:)
    end

    def complete_induction!(completion_date:, status:)
      api_client.complete_induction!(trn:, completion_date:, status:)
    end

    def check_eligibility!
      raise TRS::Errors::QTSNotAwarded unless qts_awarded?
      raise TRS::Errors::ProhibitedFromTeaching if prohibited_from_teaching?

      raise TRS::Errors::Exempt if induction_status == 'Exempt'
      raise TRS::Errors::Completed if induction_status_completed?

      true
    end

  private

    def induction_status_completed?
      %w[
        Pass
        Fail
        PassedinWales
        FailedinWales
      ].include?(induction_status)
    end

    def api_client
      @api_client ||= TRS::APIClient.new
    end

    def qts_awarded?
      @qts_awarded.present?
    end

    def prohibited_from_teaching?
      @alerts&.any? { |alert| alert.dig('alertType', 'alertCategory', 'alertCategoryId') == PROHIBITED_FROM_TEACHING_CATEGORY_ID }
    end
  end
end
