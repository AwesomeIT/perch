class RemoveSamplesFromExperiments < ActiveRecord::Migration
  def change
    remove_column :experiments, :samples
  end
end
