class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :username
      t.string :salt
      t.decimal :quality

      t.timestamps null: false
    end
  end
end
