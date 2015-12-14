class Sample < ActiveRecord::Base
  has_many :scores

  validates :name, presence: true
  validates :tags, presence: true

  has_attached_file :s3_file, :storage => :s3, :s3_credentials => {
      :bucket => Rails.application.secrets.aws_s3_bucket,
      :access_key_id => Rails.application.secrets.aws_s3_id,
      :secret_access_key => Rails.application.secrets.aws_s3_secret
  }

  validates_attachment_content_type :s3_file, content_type: "application/pdf"
end
