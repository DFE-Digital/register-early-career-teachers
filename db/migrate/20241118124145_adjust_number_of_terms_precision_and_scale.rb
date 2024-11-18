class AdjustNumberOfTermsPrecisionAndScale < ActiveRecord::Migration[7.2]
  def up
    change_column :induction_extensions, :number_of_terms, :decimal, precision: 3, scale: 1
  end

  def down
    change_column :induction_extensions, :number_of_terms, :decimal, precision: 2, scale: 1
  end
end
