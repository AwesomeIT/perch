class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :samples, :experiments do |t|
      # t.index [:sample_id, :experiment_id]
      # t.index [:experiment_id, :sample_id]
    end
  end
end
