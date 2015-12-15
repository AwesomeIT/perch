class Experiment < ActiveRecord::Base
  has_many :scores
  has_many :participants, through: :scores
  has_and_belongs_to_many :samples, join_table: 'experiments_samples', :uniq => true

  default_scope { order('id DESC') }

  acts_as_taggable

  # For data export
  def self.as_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end
end
