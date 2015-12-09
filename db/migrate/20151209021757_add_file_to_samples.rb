class AddFileToSamples < ActiveRecord::Migration
  def change
    add_column :samples, :file, :string
  end
end
