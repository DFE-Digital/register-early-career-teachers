require 'csv'

module AppropriateBodies::Importers
  class AppropriateBodyImporter
    def initialize(filename = Rails.root.join('db/samples/appropriate-body-portal/appropriate-body.csv'))
      @csv = CSV.read(filename, headers: true)
    end

    def import
      AppropriateBody.transaction do
        @csv.each do |row|
          Rails.logger.debug("attempting to import row: #{row.to_h}")

          AppropriateBody.create!(**build(row))
        end
      end

      @csv.count
    end

  private

    def build(row)
      # id                                  , name                 , dfe_sign_in_organisation_id, local_authority_code, establishment_number
      # 025e61e7-ec32-eb11-a813-000d3a228dfc, Test Appropriate Body,                            , 1000                ,
      # 69748633-ed32-eb11-a813-000d3a228dfc, ETS Test Organisation, 1234                       ,                     ,

      {
        name: row['name'].strip,

        # FIXME: we'll probably have to supply these ourselves
        #        and they're not in the sample data, so just
        #        random values for now
        dfe_sign_in_organisation_id: SecureRandom.uuid,
        legacy_id: row['id'],

        **extract_local_authority_code_and_establishment_number(row)
      }
    end

    def extract_local_authority_code_and_establishment_number(row)
      local_authority_code = row['local_authority_code']

      # the local authority code contains a mix of data in various
      # formats, e.g.,: # 51, 052, 101//101, 202, 885/5403
      #
      # 3 numbers is a local authority code (https://www.get-information-schools.service.gov.uk/Guidance/LaNameCodes)
      # e.g., 123
      #
      # 4 numbers is a establishment number
      # e.g., 1234
      #
      # 3 numbers, a slash, followed by 4 numbers is the local authority code combined
      # with with the establishment number to form the establishment ID (aka the 'DfE number')
      # e.g., 123/1234
      params = case local_authority_code
               when %r{\A[1-9]\d{2}\z}
                 {
                   local_authority_code:
                 }
               when %r{\A[1-9]\d{3}\z}
                 {
                   establishment_number: local_authority_code
                 }
               when %r{\A\d{3}/\d{4}\z}
                 {
                   local_authority_code: local_authority_code[0..2],
                   establishment_number: local_authority_code[4..8]
                 }
               else
                 Rails.logger.debug("Can't import #{local_authority_code} from #{row}")

                 {}
               end

      params.transform_values(&:to_i)
    end
  end
end
