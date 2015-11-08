class CreateErrors < ActiveRecord::Migration
  def change
    create_table :errors do |t|
      t.string :message
      t.string :path
      t.string :request

      t.timestamps null: false
    end
  end
end
