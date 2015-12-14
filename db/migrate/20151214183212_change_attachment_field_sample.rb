class ChangeAttachmentFieldSample < ActiveRecord::Migration
  def change
    remove_attachment :samples, :s3_file

    change_table :samples do |t|
      t.attachment :audio
    end
  end
end
