class Participant < ActiveRecord::Base
  validates :username, :uniqueness => true

  has_many :experiments, through: :scores
  has_many :participants, through: :scores
  has_many :scores

  # For data export
  def self.as_csv
    CSV.generate do |csv|
      csv << column_names.except('salt')
      all.each do |item|
        csv << item.attributes.values_at(*column_names.except('salt'))
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
