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

private
  @@logged_in_to_flickr = false
end