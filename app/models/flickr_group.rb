class FlickrGroup
  attr_reader :group_info

  def initialize(group_uri)
    FlickrApi.login
    @group_info = FlickrApi.lookupGroup(group_uri)
  end

  # Returns an array of these:
  #
  #   {"nsid"=>"93469079@N04", "username"=>"msmoooey", "iconserver"=>"7406", "iconfarm"=>8, "membertype"=>"2", "realname"=>"Mandy"}
  def group_members
    return FlickrApi.group_members(group_info)
  end

  # Returns an array like this:
  #
  # [{"id"=>"16152566212", "owner"=>"57460915@N07", "secret"=>"8e5277be2c", "server"=>"7572", "farm"=>8, "title"=>"Old Country Roses Pattern", "ispublic"=>1, "isfriend"=>0, "isfamily"=>0, "ownername"=>"jscollins7", "dateadded"=>"1420004161", "dateupload"=>"1420004160", "datetaken"=>"2014-12-23 08:27:48", "datetakengranularity"=>"0", "datetakenunknown"=>"0", "tags"=>"ch2014wk51"}
  def group_photos
    page_no = 1
    per_page = 500
    photos = Array.new
    loop do
      photo_list = FlickrApi.get_photos(group_info, per_page, page_no)
      break if photo_list.size == 0
      photos |= photo_list.to_a
      page_no += 1
    end
    return photos
  end

end