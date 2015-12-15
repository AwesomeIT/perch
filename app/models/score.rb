class Score < ActiveRecord::Base
  belongs_to :participant
  belongs_to :sample
  belongs_to :experiment

  validates :participant, :presence => true
  validates :sample, :presence => true
  validates :experiment, :presence => true

  after_save :update_sample

  # For data export
  def self.as_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  private

  # TODO: Figure out more semantic way of doing this
  def update_sample
    self.sample.send(:recalculate_average_and_total_scores)
  end
end
