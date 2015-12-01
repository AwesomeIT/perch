class AddTagsToSample < ActiveRecord::Migration
  def change
    add_column :samples, :tags, :string
  end
end
