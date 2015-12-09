class Renamecolumn < ActiveRecord::Migration
  def change
    rename_column :samples, :filename, :name
  end
end
