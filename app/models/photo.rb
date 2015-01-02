class Photo < ActiveRecord::Base
  belongs_to :member
  belongs_to :challenge

  validates_presence_of :flickr_id
  validates_numericality_of :flickr_id
  validates_presence_of :owner_id
  validates_presence_of :secret
  validates_presence_of :server
  validates_numericality_of :server
  validates_presence_of :farm
  validates_numericality_of :farm
  validates_presence_of :title
end
