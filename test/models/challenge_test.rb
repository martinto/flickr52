require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase

  test 'update from flickr' do
    challenge = Challenge.create! :year => DateTime.parse('2014-01-01'), :title => 'Challenge 2014', :url => 'http://www.flickr.com/groups/challenge2014/'
    challenge.update_from_flickr
    members = challenge.members
    assert_equal 16, members.count
  end
end
