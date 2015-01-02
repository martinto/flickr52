class Member < ActiveRecord::Base
  has_many :photos
  has_and_belongs_to_many :challenges

  validates_presence_of :nsid
  validates_presence_of :username
  validates_presence_of :icon_server
  validates_numericality_of :icon_server
  validates_presence_of :icon_farm
  validates_numericality_of :icon_farm
  validates_presence_of :member_type
  validates_numericality_of :member_type
end
