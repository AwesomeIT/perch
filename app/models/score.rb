class Score < ActiveRecord::Base
  belongs_to :participant
  belongs_to :sample
  belongs_to :experiment

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
