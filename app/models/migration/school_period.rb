module Migration
  # NOTE: this is a PORO to help with collating school period data when processing InductionRecords
  #       this was originally a Struct but have made it a class so that we can reference it in
  #       multiple places and make it easier to test the code that uses it
  class SchoolPeriod
    attr_accessor :urn, :start_date, :end_date, :start_source_id, :end_source_id

    def initialize(urn:, start_date:, end_date:, start_source_id:, end_source_id:)
      @urn = urn
      @start_date = start_date
      @end_date = end_date
      @start_source_id = start_source_id
      @end_source_id = end_source_id
    end
  end
end
