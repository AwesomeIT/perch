class Participant < ActiveRecord::Base
  validates :username, :uniqueness => true

  def bcrypt_salt(password)
    BCrypt::Password.create(password)
  end

  def verify_salt(password)
    BCrypt::Password.new(self.salt) == password
  end
  
end
