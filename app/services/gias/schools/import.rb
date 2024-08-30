class GIAS::Schools::Import
  def initialize(urn:, name:, local_authority:, phase:, establishment_type:, school_status:, administrative_district:, address_line1:, address_line2:, address_line3:, postcode:, primary_contact_email:, secondary_contact_email:, section_41_approved:, opened_on:, closed_on:)
    @school = GIAS::School.new(
      urn:,
      name:,
      local_authority:,
      phase:,
      establishment_type:,
      school_status:,
      administrative_district:,
      address_line1:,
      address_line2:,
      address_line3:,
      postcode:,
      primary_contact_email:,
      secondary_contact_email:,
      section_41_approved:,
      opened_on:,
      closed_on:
    )
  end

  def self.import_from_csv_row(row)
    new(
      urn: row["URN"],
      name: row["EstablishmentName"],
      local_authority: row["LA (name)"],
      phase: row["PhaseOfEducation (name)"],
      establishment_type: row["TypeOfEstablishment (name)"],
      school_status: row["EstablishmentStatus (name)"].underscore.parameterize(separator: "_").sub("open_but_", ""),
      administrative_district: row["DistrictAdministrative (name)"],
      address_line1: row["Street"],
      address_line2: row["Locality"].presence,
      address_line3: row["Town"].presence,
      postcode: row["Postcode"],
      primary_contact_email: row["MainEmail"].presence,
      secondary_contact_email: row["AlternativeEmail"].presence,
      section_41_approved: row["Section41Approved (name)"] == "Approved",
      opened_on: row["OpenDate"],
      closed_on: row["CloseDate"]
    ).save!
  end

  def save!
    @school.save!
  end
end

# SchoolCSV.each { |row| Schools::Import.import_from_csv_row(row) }
