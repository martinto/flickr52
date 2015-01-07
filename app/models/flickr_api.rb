require 'flickraw'
#FlickRaw.secure = false

class FlickrApi

  FlickRaw.api_key="d50121117e66df746c45fa9114640828"
  FlickRaw.shared_secret="9aaf3c67263862dc"

  flickr.access_token = "72157650048323002-827c4ab7746d5d8c"
  flickr.access_secret = "1364f28717acc6f2"

  attr_reader :logged_in_as, :group_info

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

  # Returns an array of these:
  #
  #   {"nsid"=>"93469079@N04", "username"=>"msmoooey", "iconserver"=>"7406", "iconfarm"=>8, "membertype"=>"2", "realname"=>"Mandy"}
  def group_members
    members = flickr.groups.members.getList(:group_id => group_info['id'], :per_page => 500, :page => 1)
  end

  # Returns an array like this:
  #
  # [{"id"=>"16152566212", "owner"=>"57460915@N07", "secret"=>"8e5277be2c", "server"=>"7572", "farm"=>8, "title"=>"Old Country Roses Pattern", "ispublic"=>1, "isfriend"=>0, "isfamily"=>0, "ownername"=>"jscollins7", "dateadded"=>"1420004161", "dateupload"=>"1420004160", "datetaken"=>"2014-12-23 08:27:48", "datetakengranularity"=>"0", "datetakenunknown"=>"0", "tags"=>"ch2014wk51"}
  def group_photos
    page_no = 1
    per_page = 500
    photos = Array.new
    loop do
      photo_list = flickr.groups.pools.getPhotos(:group_id => group_info['id'], :extras => 'date_upload, date_taken, owner_name, tags', :per_page => per_page, :page => page_no)
      break if photo_list.size == 0
      photos |= photo_list.to_a
      page_no += 1
    end
    return photos
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

private
  @@logged_in_to_flickr = false
end