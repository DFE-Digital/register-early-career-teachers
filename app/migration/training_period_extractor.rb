class TrainingPeriodExtractor
  include Enumerable

  def initialize(induction_records:)
    @induction_records = induction_records
  end

  def each(&block)
    return to_enum(__method__) { training_periods.size } unless block_given?

    training_periods.each(&block)
  end

private

  def training_periods
    @training_periods ||= build_training_periods
  end

  def build_training_periods
    current_period = nil
    current_programme = nil

    training_period = Struct.new(:training_programme, :lead_provider, :delivery_partner, :core_materials, :cohort_year, :start_date, :end_date, :start_source_id, :end_source_id)

    @induction_records.each_with_object([]) do |induction_record, periods|
      record_programme = induction_record.induction_programme

      if current_programme != record_programme
        current_programme = record_programme

        lead_provider = current_programme.partnership&.lead_provider&.name
        delivery_partner = current_programme.partnership&.delivery_partner&.name
        core_materials = current_programme.core_induction_programme&.name

        # might want to filter out FIP without partnership or CIP without materials?
        current_period = training_period.new(training_programme: current_programme.training_programme,
                                             lead_provider:,
                                             delivery_partner:,
                                             core_materials:,
                                             cohort_year: induction_record.schedule.cohort.start_year,
                                             start_date: induction_record.start_date,
                                             end_date: induction_record.end_date,
                                             start_source_id: induction_record.id,
                                             end_source_id: induction_record.id)
        periods << current_period
      else
        current_period.end_date = induction_record.end_date
        current_period.end_source_id = induction_record.id
      end
    end
  end
end
