class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.string :participant_id
      t.string :sample_id
      t.decimal :rating

      t.timestamps null: false
    end
  end
end
