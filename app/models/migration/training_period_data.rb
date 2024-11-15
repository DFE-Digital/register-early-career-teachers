module Migration
  # NOTE: this is a PORO to help with collating training period data when processing InductionRecords
  #       this was originally a Struct but have made it a class so that we can reference it in
  #       multiple places and make it easier to test the code that uses it
  class TrainingPeriodData
    attr_accessor :training_programme, :lead_provider, :delivery_partner, :core_materials, :cohort_year,
                  :start_date, :end_date, :start_source_id, :end_source_id

    def initialize(training_programme:, lead_provider:, delivery_partner:, core_materials:,
                   cohort_year:, start_date:, end_date:, start_source_id:, end_source_id:)
      @training_programme = training_programme
      @lead_provider = lead_provider
      @delivery_partner = delivery_partner
      @core_materials = core_materials
      @cohort_year = cohort_year
      @start_date = start_date
      @end_date = end_date
      @start_source_id = start_source_id
      @end_source_id = end_source_id
    end
  end
end
