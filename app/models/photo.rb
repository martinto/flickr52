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

  def get_flickr_url
    if self.flickr_url.nil?
      photo_info = FlickrApi.photo_info(self.flickr_id, self.secret)
      #{"id"=>"16152566212",
      # "secret"=>"8e5277be2c",
      # "server"=>"7572",
      # "farm"=>8,
      # "dateuploaded"=>"1420004160",
      # "isfavorite"=>0,
      # "license"=>"0",
      # "safety_level"=>"0",
      # "rotation"=>0,
      # "originalsecret"=>"48810e6337",
      # "originalformat"=>"jpg",
      # "owner"=>{"nsid"=>"57460915@N07", "username"=>"jscollins7", "realname"=>"John Collins", "location"=>"Madisonville, KY", "iconserver"=>"7435", "iconfarm"=>8, "path_alias"=>"johnecollins"},
      # "title"=>"Old Country Roses Pattern",
      # "description"=>"Old Country Roses China Pattern",
      # "visibility"=>{"ispublic"=>1, "isfriend"=>0, "isfamily"=>0},
      # "dates"=>{"posted"=>"1420004160", "taken"=>"2014-12-23 08:27:48", "takengranularity"=>"0", "takenunknown"=>"0", "lastupdate"=>"1420004160"},
      # "views"=>"21",
      # "editability"=>{"cancomment"=>1, "canaddmeta"=>1},
      # "publiceditability"=>{"cancomment"=>1, "canaddmeta"=>0},
      # "usage"=>{"candownload"=>1, "canblog"=>1, "canprint"=>0, "canshare"=>0},
      # "comments"=>"0",
      # "notes"=>[],
      # "people"=>{"haspeople"=>0},
      # "tags"=>[{"id"=>"57439585-16152566212-238969062", "author"=>"57460915@N07", "authorname"=>"jscollins7", "raw"=>"ch2014wk51", "_content"=>"ch2014wk51", "machine_tag"=>0}],
      # "urls"=>[{"type"=>"photopage", "_content"=>"https://www.flickr.com/photos/johnecollins/16152566212/"}], "media"=>"photo"}
      self.flickr_url = photo_info['urls'][0]['_content']
      save!
    end
    return self.flickr_url
  end
end
