class Sample < ActiveRecord::Base
  has_many :scores

  belongs_to :experiment

  validates :name, presence: true
  validates :tags, presence: true

  has_attached_file :audio, :storage => :s3, :s3_credentials => {
      :bucket => Rails.application.secrets.aws_s3_bucket,
      :access_key_id => Rails.application.secrets.aws_s3_id,
      :secret_access_key => Rails.application.secrets.aws_s3_secret
  }

  # Accept any audio MIME type
  validates_attachment_content_type :audio, content_type: "audio/*"
end
