class FixScoresDatatypes < ActiveRecord::Migration
  def change
    change_column :scores, :participant_id, 'integer USING CAST(participant_id AS integer)'
    change_column :scores, :experiment_id, 'integer USING CAST(experiment_id AS integer)'
    change_column :scores, :sample_id, 'integer USING CAST(sample_id AS integer)'
  end
end
