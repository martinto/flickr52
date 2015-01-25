require 'flickraw'
#FlickRaw.secure = false

class FlickrApi

  FlickRaw.api_key="d50121117e66df746c45fa9114640828"
  FlickRaw.shared_secret="9aaf3c67263862dc"

  flickr.access_token = "72157650048323002-827c4ab7746d5d8c"
  flickr.access_secret = "1364f28717acc6f2"

  attr_reader :logged_in_as

  def initialize(group_uri)
    FlickrApi.login
    @group_info = flickr.urls.lookupGroup(:url =>group_uri)
  end

  def self.login
    unless @@logged_in_to_flickr
      @logged_in_as = flickr.test.login
      @@logged_in_to_flickr = true
    end
    @logged_in_as
  end

  def self.lookupGroup(group_uri)
    return flickr.urls.lookupGroup(:url => group_uri)
  end

  # Returns an array of these:
  #
  #   {"nsid"=>"93469079@N04", "username"=>"msmoooey", "iconserver"=>"7406", "iconfarm"=>8, "membertype"=>"2", "realname"=>"Mandy"}
  def self.group_members(group_info)
    return flickr.groups.members.getList(:group_id => group_info['id'], :per_page => 500, :page => 1)
  end

  # Returns an array like this:
  #
  # [{"id"=>"16152566212", "owner"=>"57460915@N07", "secret"=>"8e5277be2c", "server"=>"7572", "farm"=>8, "title"=>"Old Country Roses Pattern", "ispublic"=>1, "isfriend"=>0, "isfamily"=>0, "ownername"=>"jscollins7", "dateadded"=>"1420004161", "dateupload"=>"1420004160", "datetaken"=>"2014-12-23 08:27:48", "datetakengranularity"=>"0", "datetakenunknown"=>"0", "tags"=>"ch2014wk51"}
  def self.get_photos(group_info, per_page, page_no)
     return flickr.groups.pools.getPhotos(:group_id => group_info['id'], :extras => 'date_upload, date_taken, owner_name, tags', :per_page => per_page, :page => page_no)
  end

  # Get information about a person from their nsid
  #
  # returns something like this:
  # "{"id"=>"92191771@N00", "nsid"=>"92191771@N00", "ispro"=>1, "can_buy_pro"=>0, "iconserver"=>"7523", "iconfarm"=>8, "path_alias"=>"martintomes", "username"=>"MartinTomes", "realname"=>"Martin Tomes", "mbox_sha1sum"=>"f4a3038b693f31caee2c7598f8893301e91d60a1", "location"=>"Steyning, UK", "timezone"=>{"label"=>"GMT: Dublin, Edinburgh, Lisbon, London", "offset"=>"+00:00"}, "description"=>"", "photosurl"=>"https://www.flickr.com/photos/martintomes/", "profileurl"=>"https://www.flickr.com/people/martintomes/", "mobileurl"=>"https://m.flickr.com/photostream.gne?id=184248", "photos"=>{"firstdatetaken"=>"2003-03-22 10:57:57", "firstdate"=>"1126505411", "count"=>6499, "views"=>"7237"}}"
  def self.person(nsid)
    FlickrApi.login
    info = flickr.people.getInfo(:user_id => nsid)
    return info
  end

  def self.photo_info(photo_id, secret)
    FlickrApi.login
    info = flickr.photos.getInfo(:photo_id => photo_id, :secret => secret)
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
    return info
  end

private
  @@logged_in_to_flickr = false
end