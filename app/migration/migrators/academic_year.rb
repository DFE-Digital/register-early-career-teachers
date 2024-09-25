module Migrators
  class AcademicYear < Migrators::Base
    def self.record_count
      cohorts.count
    end

    def self.model
      :academic_year
    end

    def self.cohorts
      ::Migration::Cohort.all
    end

    def self.reset!
      if Rails.env.development?
        ::AcademicYear.connection.execute("TRUNCATE #{::AcademicYear.table_name} RESTART IDENTITY CASCADE")
      end
    end

    def migrate!
      Rails.logger.info("Migrating #{Migration::Cohort.count} cohorts")

      migrate(self.class.cohorts) do |cohort|
        Rails.logger.info("  --> #{cohort.start_year}")
        ::AcademicYear.create!(id: cohort.start_year)
      end
    end
  end
end
