class RenameFileLinkToS3Url < ActiveRecord::Migration
  def change
    rename_column :samples, :file, :s3_url
  end
end
