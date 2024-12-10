module Migration
  class MigrationFailureComponent < ViewComponent::Base
    attr_reader :migration_failure

    def initialize(migration_failure:)
      @migration_failure = Migration::MigrationFailurePresenter.new(migration_failure)
    end

    def description
      migration_failure.failure_type
    end

    delegate :participant_profile, to: :migration_failure

    def induction_records
      participant_profile&.induction_records || []
    end
  end
end
