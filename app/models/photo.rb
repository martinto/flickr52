class Photo < ActiveRecord::Base
  belongs_to :member
  belongs_to :challenge
  belongs_to :week

  validates_presence_of :flickr_id
  validates_numericality_of :flickr_id
#  validates_presence_of :owner_id
  validates_presence_of :secret
#  validates_presence_of :title

  def week_number
    # Use date taken to work out which week this photo was taken in.
    day_of_year = date_taken.yday
    return (((day_of_year - 1) / 7).to_i) + 1
  end

  def taken_in_year?(year)
    return date_taken.year == year
  end
end
