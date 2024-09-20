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
        first_name: @first_name,
        last_name: @last_name,
        date_of_birth: @date_of_birth,
        email_address: @email_address,
        alerts: @alerts,
        induction_start_date: @induction_start_date,
        induction_status: @induction_status,
        induction_status_description: @induction_status_description,
        initial_teacher_training_provider_name: @initial_teacher_training_provider_name,
        initial_teacher_training_end_date: @initial_teacher_training_end_date,
        qts_awarded: @qts_awarded,
        qts_status_description: @qts_status_description,
      }
    end
  end
end
