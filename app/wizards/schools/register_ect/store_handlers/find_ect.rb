module Schools
  module RegisterECT
    module StoreHandlers
      class FindECT
        def initialize(wizard, store)
          @wizard = wizard
          @store = store
        end

        def perform
          trn = wizard.current_step.trn
          date_of_birth = format_date(wizard.current_step.date_of_birth)
          store.store_attrs(:find_ect, { trn: })

          trs_teacher = ::TRS::APIClient.new.find_teacher(trn:, date_of_birth:)
          store.store_attrs(:find_ect, trs_teacher.present)
        end

      private

        attr_reader :wizard, :store

        def format_date(date_of_birth)
          "#{date_of_birth[1]}/#{date_of_birth[2]}/#{date_of_birth[3]}"
        end
      end
    end
  end
end
