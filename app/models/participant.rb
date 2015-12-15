class Participant < ActiveRecord::Base
  has_many :experiments, through: :scores
  has_many :participants, through: :scores
  has_many :scores

  validates :username, :uniqueness => true
  default_scope { order('id DESC') }

  # For data export
  def self.as_csv
    CSV.generate do |csv|
      column_names.delete('salt')

      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  def bcrypt_salt(password)
    BCrypt::Password.create(password)
  end

  def verify_salt(password)
    BCrypt::Password.new(self.salt) == password
  end
  
end
