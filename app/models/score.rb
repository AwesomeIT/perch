class Score < ActiveRecord::Base
  belongs_to :participant
  belongs_to :sample
  belongs_to :experiment
end
