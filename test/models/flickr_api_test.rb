require 'test_helper'

class FlickrApiTest < ActiveSupport::TestCase

  test "logged in" do
    user_data = FlickrApi.login
    assert_equal 'MartinTomes', user_data['username']
    assert_equal '92191771@N00', user_data['id']
  end

  test 'get group info from url' do
    flickr_api = FlickrApi.new('http://www.flickr.com/groups/challenge2014/')
    group_info = flickr_api.group_info
    assert_equal '2453086@N23', group_info['id']
    assert_equal 'Challenge 2014', group_info['groupname']
  end

  test 'get group members' do
    flickr_api = FlickrApi.new('http://www.flickr.com/groups/challenge2014/')
    members = flickr_api.group_members
    assert_equal 16, members.count
    mandy = members.select { |m| m['realname'] == 'Mandy'}
    assert_equal 1, mandy.count
    assert_equal '93469079@N04', mandy.first['nsid']
  end

  test 'get group photos' do
    flickr_api = FlickrApi.new('http://www.flickr.com/groups/challenge2014/')
    photos = flickr_api.group_photos
    assert_equal 1793, photos.count
  end

  test 'get person info' do
    info = FlickrApi.person('92191771@N00')
    # "{"id"=>"92191771@N00", "nsid"=>"92191771@N00", "ispro"=>1, "can_buy_pro"=>0, "iconserver"=>"7523", "iconfarm"=>8, "path_alias"=>"martintomes", "username"=>"MartinTomes", "realname"=>"Martin Tomes", "mbox_sha1sum"=>"f4a3038b693f31caee2c7598f8893301e91d60a1", "location"=>"Steyning, UK", "timezone"=>{"label"=>"GMT: Dublin, Edinburgh, Lisbon, London", "offset"=>"+00:00"}, "description"=>"", "photosurl"=>"https://www.flickr.com/photos/martintomes/", "profileurl"=>"https://www.flickr.com/people/martintomes/", "mobileurl"=>"https://m.flickr.com/photostream.gne?id=184248", "photos"=>{"firstdatetaken"=>"2003-03-22 10:57:57", "firstdate"=>"1126505411", "count"=>6499, "views"=>"7237"}}"
    assert_equal 'martintomes', info['path_alias']
    assert_equal 'MartinTomes', info['username']
  end
end
