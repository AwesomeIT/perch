class AddExperimentIdToScores < ActiveRecord::Migration
  def change
    add_column :scores, :experiment_id, :string
  end
end
