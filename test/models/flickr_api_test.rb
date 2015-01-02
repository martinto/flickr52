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
end
