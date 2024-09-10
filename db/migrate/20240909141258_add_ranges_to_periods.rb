class AddRangesToPeriods < ActiveRecord::Migration[7.2]
  def change
    add_column :ect_at_school_periods, :range, :virtual, type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    add_column :induction_periods, :range, :virtual, type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    add_column :mentor_at_school_periods, :range, :virtual, type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    add_column :mentorship_periods, :range, :virtual, type: :daterange, as: "daterange(started_on, finished_on)", stored: true
    add_column :training_periods, :range, :virtual, type: :daterange, as: "daterange(started_on, finished_on)", stored: true
  end
end
