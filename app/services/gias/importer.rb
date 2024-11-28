require "gias/api_client"
require "csv"

module GIAS
  class Importer
    SCHOOLS_FILENAME = "ecf_tech.csv".freeze
    SCHOOL_LINKS_FILENAME = "links.csv".freeze

    def fetch
      import_only? ? fetch_and_import_only : fetch_and_update
    end

  private

    attr_reader :gias_school, :school_row

    delegate :create_school!, :school, to: :gias_school
    delegate :attributes, :eligible_for_registration?, :open?, :urn, to: :school_row

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
      @gias_files ||= GIAS::APIClient.new.get_files
    end

    def import_only?
      @import_only ||= GIAS::School.count.zero?
    end

    def import_school!
      if open?
        @gias_school = GIAS::School.create_with(attributes).find_or_create_by!(urn:)
        school || create_school!
      end
    end

    def import_schools(path: gias_files[SCHOOLS_FILENAME].path)
      CSV.foreach(path, headers: true, encoding: "ISO-8859-1:UTF-8") do |data|
        @school_row = GIAS::SchoolRow.new(data)
        if eligible_for_registration?
          import_only? ? import_school! : update_school!
        end
      end
    end

    def import_school_links(path: gias_files[SCHOOL_LINKS_FILENAME].path)
      CSV.foreach(path, headers: true, encoding: "ISO-8859-1:UTF-8") do |row|
        link_date = row.fetch("LinkEstablishedDate")
        link_type = row.fetch("LinkType")
        link_urn = row.fetch("LinkURN")
        urn = row.fetch("URN")
        gias_school = GIAS::School.find_by(urn:)

        if gias_school
          link = gias_school.gias_school_links
                            .create_with(link_date:, link_type:, link_urn:)
                            .find_or_create_by!(link_urn:)
          link.update!(link_type:) if link.link_type != link_type
        end
      end
    end

    def sync_changes!
      gias_school.assign_attributes(attributes)
      return unless gias_school.changed?

      GIAS::School.transaction do
        gias_school.save!
        # TODO: Handle gias_school.changes such as merges etc.
        #       Simple academisations type close/reopen will be just changing the :urn on the counterpart
        #       but links that are mergers and splits will need further thought
      end
    end

    def update_school!
      @gias_school = GIAS::School.find_by(urn:)
      gias_school ? sync_changes! : import_school!
    end
  end
end
