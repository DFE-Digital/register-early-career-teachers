module TRS
  class Teacher
    def initialize(data)
      @trn = data['trn']
      @first_name = data['firstName']
      @last_name = data['lastName']
      @date_of_birth = data['dateOfBirth']
      @email_address = data['emailAddress']

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
  end
end
