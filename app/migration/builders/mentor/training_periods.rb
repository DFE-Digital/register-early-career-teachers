module Builders
  module Mentor
    class TrainingPeriods
      attr_reader :teacher, :training_period_data

      def initialize(teacher:, training_period_data:)
        @teacher = teacher
        @training_period_data = training_period_data
      end

      def process!
        period_date = Data.define(:started_on, :finished_on)

        training_period_data.each do |period|
          next unless period.training_programme == "full_induction_programme"

          provider_partnership = ::ProviderPartnership.where(lead_provider: ::LeadProvider.find_by!(name: period.lead_provider),
                                                             delivery_partner: ::DeliveryPartner.find_by!(name: period.delivery_partner),
                                                             academic_year_id: period.cohort_year).first

          period_dates = period_date.new(started_on: period.start_date, finished_on: period.end_date)
          mentor_at_school_period = teacher.mentor_at_school_periods.containing_period(period_dates).first

          ::TrainingPeriod.create!(provider_partnership:,
                                   mentor_at_school_period:,
                                   started_on: period.start_date,
                                   finished_on: period.end_date,
                                   legacy_start_id: period.start_source_id,
                                   legacy_end_id: period.end_source_id)
        end
      end
    end
  end
end
