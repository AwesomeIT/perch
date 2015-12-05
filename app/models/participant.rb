class Participant < ActiveRecord::Base
  validates :username, :uniqueness => true

  def authenticate(username, salt) 
    participant = find_by(username: username)

    if participant.nil?
      false
    else
      participant.salt == salt
    end
  end
  
end
