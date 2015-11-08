class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :filename
      t.integer :total_scores
      t.decimal :avg_score
      t.decimal :expected_score

      t.timestamps null: false
    end
  end
end
