class RenameInductionExtensionNumberOfTerms < ActiveRecord::Migration[7.2]
  def change
    rename_column :induction_extensions, :extension_terms, :number_of_terms
  end
end
