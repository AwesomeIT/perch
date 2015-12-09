class Sample < ActiveRecord::Base
  validates :name, presence: true
  validates :tags, presence: true
  validates :file, presence: true
end
