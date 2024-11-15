module Builders
  class Teacher
    attr_reader :trn, :full_name, :legacy_id

    def initialize(trn:, full_name:, legacy_id: nil)
      @trn = trn
      @full_name = full_name
      @legacy_id = legacy_id
    end

    def process!
      ::Teacher.create!(trn:, first_name: parser.first_name, last_name: parser.last_name, legacy_id:)
    end

  private

    def parser
      @parser ||= Teachers::FullNameParser.new(full_name:)
    end
  end
end
