module Processors
  class Teacher
    attr_reader :trn, :full_name, :participant_profiles

    def initialize(trn:, full_name:, participant_profiles:)
      @trn = trn
      @full_name = full_name
      @participant_profiles = participant_profiles
    end

    def process!
      teacher = ::Teacher.create!(trn:, first_name:, last_name:)

      participant_profiles.find_each do |participant_profile|
        Processors::ParticipantProfile.new(teacher:, participant_profile:).process!
      end
    end

  private

    def first_name
      parts = full_name.split(' ')
      if parts.count > 2 && parts.first.downcase.in?(%w[mr mr. miss ms ms. mrs mrs. dr dr.])
        parts.second
      else
        parts.first
      end
    end

    def last_name
      # FIXME: check for suffix titles perhaps e.g. Esq.
      full_name.split(' ').last
    end
  end
end
