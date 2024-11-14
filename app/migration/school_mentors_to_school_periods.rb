class SchoolMentorsToSchoolPeriods
  include Enumerable

  attr_reader :participant_profile

  def initialize(participant_profile:)
    @participant_profile = participant_profile
  end

  def each(&block)
    return to_enum(__method__) { school_periods.size } unless block_given?

    school_periods.each(&block)
  end

private

  def school_periods
    @school_periods ||= school_mentors_to_school_periods
  end

  def school_mentors_to_school_periods
    participant_profile.school_mentors.order(:created_at).map do |school_mentor|
      Migration::SchoolPeriod.new(urn: school_mentor.school.urn,
                                  start_date: school_mentor.created_at.to_date,
                                  end_date: nil,
                                  start_source_id: school_mentor.id,
                                  end_source_id: nil)
    end
  end
end
