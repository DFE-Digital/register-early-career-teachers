module TRS
  class Teacher
    def initialize(data)
      @trn = data['trn']
      @first_name = data['firstName']
      @middle_name = data['middleName']
      @last_name = data['lastName']
      @date_of_birth = data['dateOfBirth']
      @national_insurance_number = data['nationalInsuranceNumber']
      @email_address = data['emailAddress']
      @eyts_awarded = data.dig('eyts', 'awarded')
      @eyts_certificate_url = data.dig('eyts', 'certificateUrl')
      @eyts_status_description = data.dig('eyts', 'statusDescription')

      @alerts = data['alerts']
      @induction_start_date = data.dig('induction', 'startDate')
      @induction_end_date = data.dig('induction', 'endDate')
      @induction_status = data.dig('induction', 'status')
      @induction_status_description = data.dig('induction', 'statusDescription')
      @induction_certificate_url = data.dig('induction', 'certificateUrl')

      @pending_name_change = data['pendingNameChange']
      @pending_date_of_birth_change = data['pendingDateOfBirthChange']

      @qts_awarded = data.dig('qts', 'awarded')
      @qts_certificate_url = data.dig('qts', 'certificateUrl')
      @qts_status_description = data.dig('qts', 'statusDescription')

      @initial_teacher_training = data['initialTeacherTraining']
      @npq_qualifications = data['npqQualifications']
      @mandatory_qualifications = data['mandatoryQualifications']
      @higher_education_qualifications = data['higherEducationQualifications']
      @previous_names = data['previousNames']

      @allow_id_sign_in_with_prohibitions = data['allowIdSignInWithProhibitions']
    end

    def present
      {
        trn: @trn,
        first_name: @first_name,
        middle_name: @middle_name,
        last_name: @last_name,
        date_of_birth: @date_of_birth,
        national_insurance_number: @national_insurance_number,
        email_address: @email_address,
        eyts_awarded: @eyts_awarded,
        eyts_certificate_url: @eyts_certificate_url,
        eyts_status_description: @eyts_status_description,
        alerts: @alerts,
        induction_start_date: @induction_start_date,
        induction_end_date: @induction_end_date,
        induction_status: @induction_status,
        induction_status_description: @induction_status_description,
        induction_certificate_url: @induction_certificate_url,
        pending_name_change: @pending_name_change,
        pending_date_of_birth_change: @pending_date_of_birth_change,
        qts_awarded: @qts_awarded,
        qts_certificate_url: @qts_certificate_url,
        qts_status_description: @qts_status_description,
        initial_teacher_training: @initial_teacher_training,
        npq_qualifications: @npq_qualifications,
        mandatory_qualifications: @mandatory_qualifications,
        higher_education_qualifications: @higher_education_qualifications,
        previous_names: @previous_names,
        allow_id_sign_in_with_prohibitions: @allow_id_sign_in_with_prohibitions
      }
    end
  end
end
