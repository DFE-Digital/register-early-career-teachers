module Migration
  class InductionRecordComponent < ViewComponent::Base
    attr_reader :induction_record

    def initialize(induction_record:)
      @induction_record = induction_record
    end

    def attributes_for(attr)
      {}
    end
  end
end
