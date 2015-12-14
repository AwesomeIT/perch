class RemoveS3UrlFromSample < ActiveRecord::Migration
  def change
    remove_column :samples, :s3_url
  end
end
