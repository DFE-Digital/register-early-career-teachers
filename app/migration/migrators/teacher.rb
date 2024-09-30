module Migrators
  class Teacher < Migrators::Base
    def self.record_count
      teachers.count
    end

    def self.model
      :teacher
    end

    def self.teachers
      ::Migration::TeacherProfile.where(id: ::Migration::ParticipantProfile.ect_or_mentor.select(:teacher_profile_id)).distinct.limit(50)
    end

    def self.reset!
      if Rails.env.development?
        ::Teacher.connection.execute("TRUNCATE #{::Teacher.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      Rails.logger.info("Migrating #{self.class.record_count} teachers")

      migrate(self.class.teachers.includes(:user)) do |teacher_profile|
        Rails.logger.info("  --> #{teacher_profile.id}")

        ::Teacher.create!(trn: teacher_profile.trn,
                          first_name: first_name_of(teacher_profile.user.full_name),
                          last_name: last_name_of(teacher_profile.user.full_name))
      end
    end

    def first_name_of(full_name)
      # FIXME: handle titles etc here
      full_name.split(' ').first
    end

    def last_name_of(full_name)
      # FIXME: check for suffix titles perhaps e.g. Esq.
      full_name.split(' ').last
    end
  end
end
