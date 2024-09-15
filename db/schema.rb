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

ActiveRecord::Schema[7.2].define(version: 2024_09_15_123828) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "funding_eligibility_status", ["eligible_for_fip", "eligible_for_cip", "ineligible"]
  create_enum "gias_school_statuses", ["open", "closed", "proposed_to_close", "proposed_to_open"]
  create_enum "induction_eligibility_status", ["eligible", "ineligible"]
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
    t.integer "local_authority_code", null: false
    t.integer "establishment_number", null: false
    t.virtual "establishment_id", type: :string, as: "((((local_authority_code)::character varying)::text || '/'::text) || ((establishment_number)::character varying)::text)", stored: true
    t.index ["local_authority_code", "establishment_number"], name: "idx_on_local_authority_code_establishment_number_039c79cd09", unique: true
    t.index ["name"], name: "index_appropriate_bodies_on_name", unique: true
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

  create_table "ect_at_school_periods", force: :cascade do |t|
    t.bigint "school_id", null: false
    t.bigint "teacher_id", null: false
    t.date "started_on", null: false
    t.date "finished_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "range", type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    t.index "teacher_id, ((finished_on IS NULL))", name: "index_ect_at_school_periods_on_teacher_id_finished_on_IS_NULL", unique: true, where: "(finished_on IS NULL)"
    t.index ["school_id", "teacher_id", "started_on"], name: "index_ect_at_school_periods_on_school_id_teacher_id_started_on", unique: true
    t.index ["school_id"], name: "index_ect_at_school_periods_on_school_id"
    t.index ["teacher_id", "started_on"], name: "index_ect_at_school_periods_on_teacher_id_started_on", unique: true
    t.index ["teacher_id"], name: "index_ect_at_school_periods_on_teacher_id"
  end

  create_table "gias_schools", primary_key: "urn", force: :cascade do |t|
    t.string "name", null: false
    t.integer "local_authority"
    t.string "phase"
    t.string "establishment_type"
    t.enum "school_status", default: "open", null: false, enum_type: "gias_school_statuses"
    t.enum "induction_eligibility", null: false, enum_type: "induction_eligibility_status"
    t.enum "funding_eligibility", null: false, enum_type: "funding_eligibility_status"
    t.string "administrative_district"
    t.string "address_line1"
    t.string "address_line2"
    t.string "address_line3"
    t.string "postcode"
    t.string "primary_contact_email"
    t.string "secondary_contact_email"
    t.boolean "section_41_approved"
    t.date "opened_on"
    t.date "closed_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "induction_periods", force: :cascade do |t|
    t.bigint "appropriate_body_id", null: false
    t.bigint "ect_at_school_period_id", null: false
    t.date "started_on", null: false
    t.date "finished_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "induction_programme", null: false, enum_type: "induction_programme"
    t.integer "number_of_terms"
    t.virtual "range", type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    t.index "ect_at_school_period_id, ((finished_on IS NULL))", name: "idx_on_ect_at_school_period_id_finished_on_IS_NULL_be6c214e9d", unique: true, where: "(finished_on IS NULL)"
    t.index ["appropriate_body_id"], name: "index_induction_periods_on_appropriate_body_id"
    t.index ["ect_at_school_period_id", "started_on"], name: "index_induction_periods_on_ect_at_school_period_id_started_on", unique: true
    t.index ["ect_at_school_period_id"], name: "index_induction_periods_on_ect_at_school_period_id"
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
    t.index "ect_at_school_period_id, ((finished_on IS NULL))", name: "idx_on_ect_at_school_period_id_finished_on_IS_NULL_afd5cf131d", unique: true, where: "(finished_on IS NULL)"
    t.index ["ect_at_school_period_id", "started_on"], name: "index_mentorship_periods_on_ect_at_school_period_id_started_on", unique: true
    t.index ["ect_at_school_period_id"], name: "index_mentorship_periods_on_ect_at_school_period_id"
    t.index ["mentor_at_school_period_id", "ect_at_school_period_id", "started_on"], name: "idx_on_mentor_at_school_period_id_ect_at_school_per_d69dffeecc", unique: true
    t.index ["mentor_at_school_period_id"], name: "index_mentorship_periods_on_mentor_at_school_period_id"
  end

  create_table "pending_induction_submissions", force: :cascade do |t|
    t.bigint "appropriate_body_id"
    t.string "establishment_id", limit: 8
    t.string "trn", limit: 7, null: false
    t.string "first_name", limit: 80
    t.string "last_name", limit: 80
    t.date "date_of_birth"
    t.string "induction_status", limit: 16
    t.enum "induction_programme", enum_type: "induction_programme"
    t.date "started_on"
    t.date "finished_on"
    t.integer "number_of_terms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
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
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_schools_on_name", unique: true
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
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trn", null: false
    t.index ["name"], name: "index_teachers_on_name"
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

  add_foreign_key "ect_at_school_periods", "schools"
  add_foreign_key "ect_at_school_periods", "teachers"
  add_foreign_key "induction_periods", "appropriate_bodies"
  add_foreign_key "induction_periods", "ect_at_school_periods"
  add_foreign_key "mentor_at_school_periods", "schools"
  add_foreign_key "mentor_at_school_periods", "teachers"
  add_foreign_key "mentorship_periods", "ect_at_school_periods"
  add_foreign_key "mentorship_periods", "mentor_at_school_periods"
  add_foreign_key "pending_induction_submissions", "appropriate_bodies"
  add_foreign_key "provider_partnerships", "academic_years", primary_key: "year"
  add_foreign_key "provider_partnerships", "delivery_partners"
  add_foreign_key "provider_partnerships", "lead_providers"
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
