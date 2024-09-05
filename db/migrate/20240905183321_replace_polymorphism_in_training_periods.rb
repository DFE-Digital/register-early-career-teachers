class ReplacePolymorphismInTrainingPeriods < ActiveRecord::Migration[7.2]
  def change
    remove_index :training_periods, "trainee_id, trainee_type, ((finished_on IS NULL))", if_exists: true
    remove_index :training_periods, "trainee_id, trainee_type, started_on", if_exists: true
    remove_index :training_periods, name: "provider_partnership_trainings", column: "provider_partnership_id, trainee_id, trainee_type, started_on", if_exists: true
    remove_reference :training_periods, :trainee, null: false, polymorphic: true

    add_reference :training_periods, :ect_at_school_period, foreign_key: true
    add_reference :training_periods, :mentor_at_school_period, foreign_key: true
    add_index :training_periods, "ect_at_school_period_id, mentor_at_school_period_id, ((finished_on IS NULL))", unique: true, where: "(finished_on IS NULL)"
    add_index :training_periods, %i[ect_at_school_period_id mentor_at_school_period_id started_on], unique: true
    add_index :training_periods, %i[provider_partnership_id ect_at_school_period_id mentor_at_school_period_id started_on], unique: true, name: "provider_partnership_trainings"
  end
end
