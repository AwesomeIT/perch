class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.string :name
      t.string :expiry_date
      t.string :tags
      t.string :samples

      t.timestamps null: false
    end
  end
end
