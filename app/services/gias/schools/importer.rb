# frozen_string_literal: true

require "gias/api_client"
require "csv"

module GIAS
  module Schools
    class Importer
      include Types

      SCHOOLS_FILENAME = "ecf_tech.csv".freeze
      SCHOOL_LINKS_FILENAME = "links.csv".freeze

      def fetch
        import_only? ? fetch_and_import_only : fetch_and_update
      end

    private

      def eligible_row?(row)
        establishment_type = row.fetch("TypeOfEstablishment (code)").to_i

        english_district?(row.fetch("DistrictAdministrative (code)")) &&
          (eligible_type?(establishment_type) ||
            cip_only_type?(establishment_type) ||
            row.fetch("Section41Approved (name)") == "Approved")
      end

      def funding_eligibility?(data)
        establishment_type = data.fetch("TypeOfEstablishment (code)").to_i

        english_district?(data.fetch("DistrictAdministrative (code)")) &&
          (eligible_type?(establishment_type) ||
            cip_only_type?(establishment_type) ||
            row.fetch("Section41Approved (name)") == "Approved")
      end

      def extract_values_from(changes_hash)
        changes_hash.transform_values(&:last)
      end

      # import only doesn't try to work out what has changed and does not include "closed" schools
      # we need to import schools first in an empty DB
      def fetch_and_import_only
        import_schools
        import_school_links
      end

      def fetch_and_update
        import_school_links
        import_schools
      end

      def gias_files
        @gias_files ||= gias_api_client.get_files
      end

      def gias_api_client
        @gias_api_client ||= GIAS::APIClient.new
      end

      def import_only?
        GIAS::School.count.zero?
      end

      def import_school(attrs)
        return if attrs.fetch(:status).in?(%w[closed proposed_to_open])

        GIAS::School.create_with(attrs).find_or_create_by!(urn: attrs.fetch(:urn)).tap do |gias_school|
          debugger

          gias_school.create_school! unless gias_school.school
        end
      end

      def import_schools(file: school_file)
        CSV.foreach(file, headers: true, encoding: "ISO-8859-1:UTF-8") do |row|
          next unless eligible_row?(row)

          import_only? ? import_school(school_attributes(row)) : update_school(school_attributes(row))
        end
      end

      def import_school_links(file: school_links_file)
        CSV.foreach(file, headers: true, encoding: "ISO-8859-1:UTF-8") do |row|
          attrs = link_attributes(row)
          school = GIAS::School.find_by(urn: attrs[:urn])

          if school.present?
            link = school.school_links.find_by(link_urn: attrs[:link_urn])
            return school.school_links.create!(attrs.except(:urn)) unless link

            link.update!(link_type: attrs[:link_type]) if link.link_type != attrs[:link_type]
          end
        end
      end

      def link_attributes(data)
        {
          link_date: data.fetch("LinkEstablishedDate"),
          link_type: data.fetch("LinkType"),
          link_urn: data.fetch("LinkURN"),
          urn: data.fetch("URN"),
        }
      end

      def make_status_value(status)
        status.underscore.parameterize(separator: "_").sub("open_but_", "")
      end

      def school_attributes(data)
        {
          address_line1: data.fetch("Street"),
          address_line2: data.fetch("Locality").presence,
          address_line3: data.fetch("Town").presence,
          administrative_district_code: data.fetch("DistrictAdministrative (code)"),
          administrative_district_name: data.fetch("DistrictAdministrative (name)"),
          closed_on: data.fetch("CloseDate"),
          easting: data.fetch("Easting").to_i,
          establishment_number: data.fetch("EstablishmentNumber").presence,
          induction_eligibility: :eligible,
          local_authority_code: data.fetch("LA (code)").to_i,
          name: data.fetch("EstablishmentName"),
          northing: data.fetch("Northing").to_i,
          opened_on: data.fetch("OpenDate"),
          phase_code: data.fetch("PhaseOfEducation (code)").to_i,
          phase_name: data.fetch("PhaseOfEducation (name)"),
          postcode: data.fetch("Postcode"),
          primary_contact_email: data.fetch("MainEmail").presence,
          secondary_contact_email: data.fetch("AlternativeEmail").presence,
          section_41_approved: data.fetch("Section41Approved (name)") == "Approved",
          status: make_status_value(data.fetch("EstablishmentStatus (name)")),
          type_code: data.fetch("TypeOfEstablishment (code)").to_i,
          type_name: data.fetch("TypeOfEstablishment (name)"),
          ukprn: data.fetch("UKPRN").presence,
          urn: data.fetch("URN").to_i,
          website: data.fetch("SchoolWebsite").presence,
        }
      end

      def school_file
        gias_files[SCHOOLS_FILENAME].path
      end

      def school_links_file
        gias_files[SCHOOL_LINKS_FILENAME].path
      end

      def sync_changes!(gias_school, attrs)
        gias_school.assign_attributes(attrs)
        return unless gias_school.changed?

        GIAS::School.transaction do
          gias_school.save!

          # TODO: Handle gias_school.changes such as merges etc.
          #       Simple academisations type close/reopen will be just changing the :urn on the conterpart
          #       but links that are mergers and splits will need further thought
        end
      end

      def update_school(attrs)
        gias_school = GIAS::School.find_by(urn: attrs.fetch(:urn))
        gias_school.present? ? sync_changes!(gias_school, attrs) : import_school(attrs)
      end
    end
  end
end
