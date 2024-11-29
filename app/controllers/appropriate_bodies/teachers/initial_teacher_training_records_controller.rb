module AppropriateBodies
  module Teachers
    class InitialTeacherTrainingRecordsController < AppropriateBodiesController
      # [
      #   {
      #   "provider": {
      #     "name": "string",
      #     "ukprn": "string"
      #   },
      #   "qualification": {
      #     "name": "string"
      #   },
      #   "startDate": {
      #     "hasValue": true,
      #     "value": "2024-11-29"
      #   },
      #   "endDate": {
      #     "hasValue": true,
      #     "value": "2024-11-29"
      #   },
      #   "programmeType": {
      #     "hasValue": true,
      #     "value": "Apprenticeship"
      #   },
      #   "programmeTypeDescription": "string",
      #   "result": {
      #     "hasValue": true,
      #     "value": "Pass"
      #   },
      #   "ageRange": {
      #     "description": "string"
      #   },
      #   "subjects": [
      #     {
      #       "code": "string",
      #       "name": "string"
      #     }
      #   ]
      # ]
      ITTData = Struct.new(
        :provider_name,
        :provider_ukprn,
        :qualification,
        :start_date,
        :end_date,
        :programme_type,
        :programme_type_description,
        :age_range,
        :subjects,
        keyword_init: true
      )

      def index
        @teacher = find_teacher

        @itt_data = [
          ITTData.new(
            provider_name: "Education Development Trust",
            programme_type: "Future Teaching Scholars",
            start_date: 3.years.ago.to_date + 13.days,
            end_date: 1.year.ago.to_date - 40.days,
            subjects: %w[Maths English],
            age_range: "5-11"
          ),
          # ITTData.new(
          #   provider_name: "Some provider",
          #   programme_type: "Teach First Programme",
          #   start_date: 24.weeks.ago.to_date,
          #   end_date: 47.days.ago.to_date,
          #   subjects: %w[Science],
          #   age_range: "12-18"
          # )
        ]
      end

    private

      def find_teacher
        AppropriateBodies::CurrentTeachers.new(@appropriate_body).current.find_by!(trn: params[:teacher_trn])
      end
    end
  end
end
