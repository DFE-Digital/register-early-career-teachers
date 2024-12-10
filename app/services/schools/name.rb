module Schools
  class Name
    attr_accessor :school

    def initialize(school)
      @school = school
    end

    def name_and_urn
      "#{school.name} (#{school.urn})"
    end
  end
end
