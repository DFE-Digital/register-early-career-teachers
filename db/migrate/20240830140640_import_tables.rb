class ImportTables < ActiveRecord::Migration[7.2]
  def change
    create_table :academic_years do |t|
      t.integer :year, null: false

      t.timestamps
    end

    create_table :lead_providers do |t|
      t.string :name

      t.timestamps
    end

    create_table :delivery_partners do |t|
      t.string :name

      t.timestamps
    end

    create_table :teachers do |t|
      t.string :name

      t.timestamps
    end

    create_table :appropriate_bodies do |t|
      t.string :name

      t.timestamps
    end

    create_enum :gias_school_statuses, %w[open closed proposed_to_close proposed_to_open]

    create_table :gias_schools, primary_key: :urn do |t|
      t.string :name, null: false
      t.integer :local_authority
      t.string :school_phase
      t.string :school_type

      t.enum :school_status, default: "open", null: false, enum_type: :gias_school_statuses

      t.string :administrative_district

      t.string :address_line1
      t.string :address_line2
      t.string :address_line3
      t.string :postcode

      t.string :primary_contact_email
      t.string :secondary_contact_email
      t.boolean :section_41_approved
      t.date :opened_on
      t.date :closed_on

      t.timestamps
    end

    create_enum :induction_eligibility_status, %w[eligible ineligible]
    create_enum :funding_eligibility_status, %w[eligible_for_fip eligible_for_cip ineligible]

    create_table :schools do |t|
      t.integer :urn, null: false, index: { unique: true, name: "schools_unique_urn" }
      t.enum :induction_eligibility, null: false, enum_type: :induction_eligibility_status
      t.enum :funding_eligibility, null: false, enum_type: :funding_eligibility_status

      t.timestamps
    end

    create_table :ect_at_school_periods do |t|
      t.references :school
      t.references :teacher
      t.date :started_on, null: false
      t.date :finished_on
      t.index "school_id, teacher_id, ((finished_on IS NULL))", unique: true, where: "(finished_on IS NULL)"

      t.timestamps
    end

    create_table :mentor_at_school_periods do |t|
      t.references :school
      t.references :teacher
      t.date :started_on, null: false
      t.date :finished_on
      t.index "school_id, teacher_id, ((finished_on IS NULL))", unique: true, where: "(finished_on IS NULL)"

      t.timestamps
    end

    create_table :mentorship_periods do |t|
      t.references :ect_at_school_period
      t.references :mentor_at_school_period
      t.date :started_on, null: false
      t.date :finished_on
      t.index "ect_at_school_period_id, mentor_at_school_period_id, ((finished_on IS NULL))", unique: true, where: "(finished_on IS NULL)"

      t.timestamps
    end

    create_table :provider_partnerships do |t|
      t.references :academic_year
      t.references :lead_provider
      t.references :delivery_partner

      t.timestamps
    end

    create_table :training_periods do |t|
      t.references :provider_partnership
      t.references :ect_at_school_period
      t.references :mentor_at_school_period
      t.date :started_on, null: false
      t.date :finished_on
      t.index "ect_at_school_period_id, mentor_at_school_period_id, provider_partnership_id, ((finished_on IS NULL))", unique: true, where: "(finished_on IS NULL)"

      t.timestamps
    end

    create_table :declarations do |t|
      t.references :training_period
      t.string :declaration_type

      t.timestamps
    end

    create_table :induction_periods do |t|
      t.references :ect_at_school_period
      t.references :appropriate_body
      t.date :started_on, null: false
      t.date :finished_on
      t.index "ect_at_school_period_id, ((finished_on IS NULL))", unique: true, where: "(finished_on IS NULL)"

      t.timestamps
    end
  end
end
