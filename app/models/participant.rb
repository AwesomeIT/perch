class Participant < ActiveRecord::Base
  validates :username, :uniqueness => true
end
