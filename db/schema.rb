# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_15_110325) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "dfe_role_type", ["admin", "super_admin", "finance"]
  create_enum "funding_eligibility_status", ["eligible_for_fip", "eligible_for_cip", "ineligible"]
  create_enum "gias_school_statuses", ["open", "closed", "proposed_to_close", "proposed_to_open"]
  create_enum "induction_outcomes", ["fail", "pass"]
  create_enum "induction_programme", ["cip", "fip", "diy"]

  create_table "academic_years", primary_key: "year", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year"], name: "index_academic_years_on_year", unique: true
  end

  create_table "appropriate_bodies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "local_authority_code"
    t.integer "establishment_number"
    t.uuid "dfe_sign_in_organisation_id", null: false
    t.uuid "legacy_id"
    t.index ["dfe_sign_in_organisation_id"], name: "index_appropriate_bodies_on_dfe_sign_in_organisation_id", unique: true
    t.index ["local_authority_code", "establishment_number"], name: "idx_on_local_authority_code_establishment_number_039c79cd09", unique: true
    t.index ["name"], name: "index_appropriate_bodies_on_name", unique: true
  end

  create_table "data_migrations", force: :cascade do |t|
    t.string "model", null: false
    t.integer "processed_count", default: 0, null: false
    t.integer "failure_count", default: 0, null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "total_count"
    t.datetime "queued_at"
    t.integer "worker"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "declarations", force: :cascade do |t|
    t.bigint "training_period_id"
    t.string "declaration_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["training_period_id"], name: "index_declarations_on_training_period_id"
  end

  create_table "delivery_partners", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_delivery_partners_on_name", unique: true
  end

  create_table "dfe_roles", force: :cascade do |t|
    t.enum "role_type", default: "admin", null: false, enum_type: "dfe_role_type"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_dfe_roles_on_user_id"
  end

  create_table "ect_at_school_periods", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "teacher_id", null: false
    t.date "started_on", null: false
    t.date "finished_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "range", type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    t.uuid "legacy_start_id"
    t.uuid "legacy_end_id"
    t.index "teacher_id, ((finished_on IS NULL))", name: "index_ect_at_school_periods_on_teacher_id_finished_on_IS_NULL", unique: true, where: "(finished_on IS NULL)"
    t.index ["school_id", "teacher_id", "started_on"], name: "index_ect_at_school_periods_on_school_id_teacher_id_started_on", unique: true
    t.index ["school_id"], name: "index_ect_at_school_periods_on_school_id"
    t.index ["teacher_id", "started_on"], name: "index_ect_at_school_periods_on_teacher_id_started_on", unique: true
    t.index ["teacher_id"], name: "index_ect_at_school_periods_on_teacher_id"
  end

  create_table "gias_school_links", force: :cascade do |t|
    t.integer "urn", null: false
    t.integer "link_urn", null: false
    t.string "link_type", null: false
    t.date "link_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["urn"], name: "index_gias_school_links_on_urn"
  end

  create_table "gias_schools", primary_key: "urn", force: :cascade do |t|
    t.string "name", null: false
    t.enum "status", default: "open", null: false, enum_type: "gias_school_statuses"
    t.enum "funding_eligibility", null: false, enum_type: "funding_eligibility_status"
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_line3"
    t.string "postcode"
    t.string "primary_contact_email"
    t.string "secondary_contact_email"
    t.date "opened_on"
    t.date "closed_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "administrative_district_name"
    t.integer "local_authority_code", null: false
    t.string "local_authority_name"
    t.integer "establishment_number", null: false
    t.string "phase_name"
    t.boolean "section_41_approved", null: false
    t.string "type_name", null: false
    t.integer "ukprn"
    t.string "website"
    t.boolean "induction_eligibility", null: false
    t.boolean "in_england", null: false
    t.virtual "search", type: :tsvector, as: "to_tsvector('unaccented'::regconfig, ((((COALESCE((name)::text, ''::text) || ' '::text) || COALESCE((postcode)::text, ''::text)) || ' '::text) || COALESCE((urn)::text, ''::text)))", stored: true
    t.index ["name"], name: "index_gias_schools_on_name"
    t.index ["search"], name: "index_gias_schools_on_search", using: :gin
    t.index ["ukprn"], name: "index_gias_schools_on_ukprn", unique: true
  end

  create_table "induction_extensions", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.decimal "number_of_terms", precision: 2, scale: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id"], name: "index_induction_extensions_on_teacher_id"
  end

  create_table "induction_periods", force: :cascade do |t|
    t.bigint "appropriate_body_id", null: false
    t.date "started_on", null: false
    t.date "finished_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "induction_programme", null: false, enum_type: "induction_programme"
    t.integer "number_of_terms"
    t.virtual "range", type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    t.bigint "teacher_id"
    t.index ["appropriate_body_id"], name: "index_induction_periods_on_appropriate_body_id"
    t.index ["teacher_id"], name: "index_induction_periods_on_teacher_id"
  end

  create_table "lead_providers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_lead_providers_on_name", unique: true
  end

  create_table "mentor_at_school_periods", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "teacher_id", null: false
    t.date "started_on", null: false
    t.date "finished_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "range", type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    t.uuid "legacy_start_id"
    t.uuid "legacy_end_id"
    t.index "school_id, teacher_id, ((finished_on IS NULL))", name: "idx_on_school_id_teacher_id_finished_on_IS_NULL_dd7ee16a28", unique: true, where: "(finished_on IS NULL)"
    t.index ["school_id", "teacher_id", "started_on"], name: "idx_on_school_id_teacher_id_started_on_17d46e7783", unique: true
    t.index ["school_id"], name: "index_mentor_at_school_periods_on_school_id"
    t.index ["teacher_id", "started_on"], name: "index_mentor_at_school_periods_on_teacher_id_started_on", unique: true
    t.index ["teacher_id"], name: "index_mentor_at_school_periods_on_teacher_id"
  end

  create_table "mentorship_periods", force: :cascade do |t|
    t.bigint "ect_at_school_period_id", null: false
    t.bigint "mentor_at_school_period_id", null: false
    t.date "started_on", null: false
    t.date "finished_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "range", type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    t.uuid "legacy_start_id"
    t.uuid "legacy_end_id"
    t.index "ect_at_school_period_id, ((finished_on IS NULL))", name: "idx_on_ect_at_school_period_id_finished_on_IS_NULL_afd5cf131d", unique: true, where: "(finished_on IS NULL)"
    t.index ["ect_at_school_period_id", "started_on"], name: "index_mentorship_periods_on_ect_at_school_period_id_started_on", unique: true
    t.index ["ect_at_school_period_id"], name: "index_mentorship_periods_on_ect_at_school_period_id"
    t.index ["mentor_at_school_period_id", "ect_at_school_period_id", "started_on"], name: "idx_on_mentor_at_school_period_id_ect_at_school_per_d69dffeecc", unique: true
    t.index ["mentor_at_school_period_id"], name: "index_mentorship_periods_on_mentor_at_school_period_id"
  end

  create_table "migration_failures", force: :cascade do |t|
    t.bigint "data_migration_id", null: false
    t.json "item", null: false
    t.string "failure_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_migration_id"], name: "index_migration_failures_on_data_migration_id"
  end

  create_table "pending_induction_submissions", force: :cascade do |t|
    t.bigint "appropriate_body_id"
    t.string "establishment_id", limit: 8
    t.string "trn", limit: 7, null: false
    t.string "trs_first_name", limit: 80
    t.string "trs_last_name", limit: 80
    t.date "date_of_birth"
    t.string "trs_induction_status", limit: 16
    t.enum "induction_programme", enum_type: "induction_programme"
    t.date "started_on"
    t.date "finished_on"
    t.integer "number_of_terms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.string "trs_email_address"
    t.jsonb "trs_alerts"
    t.date "trs_induction_start_date"
    t.string "trs_induction_status_description"
    t.string "trs_qts_status_description"
    t.date "trs_initial_teacher_training_end_date"
    t.string "trs_initial_teacher_training_provider_name"
    t.enum "outcome", enum_type: "induction_outcomes"
    t.date "trs_qts_awarded"
    t.index ["appropriate_body_id"], name: "index_pending_induction_submissions_on_appropriate_body_id"
  end

  create_table "provider_partnerships", force: :cascade do |t|
    t.bigint "academic_year_id", null: false
    t.bigint "lead_provider_id", null: false
    t.bigint "delivery_partner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["academic_year_id", "lead_provider_id", "delivery_partner_id"], name: "yearly_unique_provider_partnerships", unique: true
    t.index ["academic_year_id"], name: "index_provider_partnerships_on_academic_year_id"
    t.index ["delivery_partner_id"], name: "index_provider_partnerships_on_delivery_partner_id"
    t.index ["lead_provider_id"], name: "index_provider_partnerships_on_lead_provider_id"
  end

  create_table "schools", force: :cascade do |t|
    t.integer "urn", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["urn"], name: "schools_unique_urn", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "teachers", force: :cascade do |t|
    t.string "corrected_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trn", null: false
    t.datetime "induction_start_date_submitted_to_trs_at"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.virtual "search", type: :tsvector, as: "to_tsvector('unaccented'::regconfig, (((((COALESCE(first_name, ''::character varying))::text || ' '::text) || (COALESCE(last_name, ''::character varying))::text) || ' '::text) || (COALESCE(corrected_name, ''::character varying))::text))", stored: true
    t.uuid "legacy_id"
    t.uuid "legacy_ect_id"
    t.uuid "legacy_mentor_id"
    t.index ["corrected_name"], name: "index_teachers_on_corrected_name"
    t.index ["first_name", "last_name", "corrected_name"], name: "index_teachers_on_first_name_and_last_name_and_corrected_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["search"], name: "index_teachers_on_search", using: :gin
    t.index ["trn"], name: "index_teachers_on_trn", unique: true
  end

  create_table "training_periods", force: :cascade do |t|
    t.bigint "provider_partnership_id", null: false
    t.date "started_on", null: false
    t.date "finished_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ect_at_school_period_id"
    t.bigint "mentor_at_school_period_id"
    t.virtual "range", type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    t.uuid "legacy_start_id"
    t.uuid "legacy_end_id"
    t.index "ect_at_school_period_id, mentor_at_school_period_id, ((finished_on IS NULL))", name: "idx_on_ect_at_school_period_id_mentor_at_school_per_42bce3bf48", unique: true, where: "(finished_on IS NULL)"
    t.index ["ect_at_school_period_id", "mentor_at_school_period_id", "started_on"], name: "idx_on_ect_at_school_period_id_mentor_at_school_per_70f2bb1a45", unique: true
    t.index ["ect_at_school_period_id"], name: "index_training_periods_on_ect_at_school_period_id"
    t.index ["mentor_at_school_period_id"], name: "index_training_periods_on_mentor_at_school_period_id"
    t.index ["provider_partnership_id", "ect_at_school_period_id", "mentor_at_school_period_id", "started_on"], name: "provider_partnership_trainings", unique: true
    t.index ["provider_partnership_id"], name: "index_training_periods_on_provider_partnership_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "otp_secret"
    t.datetime "otp_verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "dfe_roles", "users"
  add_foreign_key "ect_at_school_periods", "schools"
  add_foreign_key "ect_at_school_periods", "teachers"
  add_foreign_key "gias_school_links", "gias_schools", column: "urn", primary_key: "urn"
  add_foreign_key "induction_extensions", "teachers"
  add_foreign_key "induction_periods", "appropriate_bodies"
  add_foreign_key "induction_periods", "teachers"
  add_foreign_key "mentor_at_school_periods", "schools"
  add_foreign_key "mentor_at_school_periods", "teachers"
  add_foreign_key "mentorship_periods", "ect_at_school_periods"
  add_foreign_key "mentorship_periods", "mentor_at_school_periods"
  add_foreign_key "pending_induction_submissions", "appropriate_bodies"
  add_foreign_key "provider_partnerships", "academic_years", primary_key: "year"
  add_foreign_key "provider_partnerships", "delivery_partners"
  add_foreign_key "provider_partnerships", "lead_providers"
  add_foreign_key "schools", "gias_schools", column: "urn", primary_key: "urn"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "training_periods", "ect_at_school_periods"
  add_foreign_key "training_periods", "mentor_at_school_periods"
  add_foreign_key "training_periods", "provider_partnerships"
end
