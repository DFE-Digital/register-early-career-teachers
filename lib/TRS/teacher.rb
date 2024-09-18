module TRS
  class Teacher
    attr_reader :trn, :first_name, :middle_name, :last_name, :date_of_birth,
                :national_insurance_number, :email_address, :eyts

    def initialize(data)
      @trn = data['trn']
      @first_name = data['firstName']
      @middle_name = data['middleName']
      @last_name = data['lastName']
      @date_of_birth = data['dateOfBirth']
      @national_insurance_number = data['nationalInsuranceNumber']
      @email_address = data['emailAddress']
      @eyts = data['eyts']
    end
  end
end
