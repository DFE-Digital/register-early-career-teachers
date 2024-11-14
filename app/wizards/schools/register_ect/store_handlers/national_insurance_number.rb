module Schools
  module RegisterECT
    module StoreHandlers
      class NationalInsuranceNumber
        def initialize(wizard, store)
          @wizard = wizard
          @store = store
        end

        def perform
          # get the teacher details from the TRS API and store in session
          ect = Schools::TeacherPresenter.new(**wizard.stored_attrs)
          trn = ect.trn
          national_insurance_number = wizard.current_step.national_insurance_number
          trs_teacher = ::TRS::APIClient.new.find_teacher(trn:, national_insurance_number:)

          store.store_attrs(:find_ect, trs_teacher)
        end

        private

        attr_reader :wizard, :store
      end
    end
  end
end
