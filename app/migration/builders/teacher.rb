module Builders
  class Teacher
    attr_reader :trn, :full_name

    def initialize(trn:, full_name:)
      @trn = trn
      @full_name = full_name
    end

    def process!
      ::Teacher.create!(trn:, first_name: parser.first_name, last_name: parser.last_name)
    end

  private

    def parser
      @parser ||= Teachers::FullNameParser.new(full_name:)
    end
  end
end
