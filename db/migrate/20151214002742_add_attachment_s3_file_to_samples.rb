class AddAttachmentS3FileToSamples < ActiveRecord::Migration
  def self.up
    change_table :samples do |t|
      t.attachment :s3_file
    end
  end

  def self.down
    remove_attachment :samples, :s3_file
  end
end
