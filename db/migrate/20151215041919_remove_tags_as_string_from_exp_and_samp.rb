class RemoveTagsAsStringFromExpAndSamp < ActiveRecord::Migration
  def change
    remove_column :samples, :tags
    remove_column :experiments, :tags
  end
end
