require 'test_helper'
require 'active_record/fixtures'

class ChallengeTest < ActiveSupport::TestCase

  def setup
    [ 'challenges', 'members', 'challenges_members', 'event_logs', 'photos', 'weeks' ].each do |fixture|
      ActiveRecord::FixtureSet.create_fixtures(Rails.root.join('test', 'fixtures'), fixture)
    end
    @challenge = Challenge.find_by_title('Challenge 2013')
  end

  test 'update from flickr' do
    assert_equal 39, @challenge.members.count
    assert_equal 23, @challenge.members.where('member_type != 0').count
    assert_equal 1304, @challenge.photos.count
  end

  test 'topic for week' do
    assert_equal 'Looking up/down', @challenge.topic(4)
    assert_equal 'Flash photography', @challenge.topic(31)
  end

  test 'check photos' do
    result = @challenge.flickr_check_photos
    assert_equal 3, result.count # Three arrays in the hash
    wrong_year = result[:wrong_year]
    assert_equal 3, wrong_year.count
    dreaming = wrong_year.select { |e| e[:photo].flickr_id == 8773587700 }.first
    assert_equal '\'Dreaming - Challenge 2013 Week 17 (software created)\' was taken in 2012 for the 2013 challenge', dreaming[:message]

    no_tag = result[:no_tag]
    assert_equal 7, no_tag.count
    ch2013wk44 = no_tag.select { |e| e[:photo].flickr_id == 10562865935 }.first
    assert_equal 'No challenge tag, it should be ch2013wk44 (Colour)', ch2013wk44[:message]

    wrong_tag = result[:wrong_tag]
    assert_equal 81, wrong_tag.count
    reflections = wrong_tag.select { |e| e[:photo].flickr_id == 11553910906 }.first
    assert_equal 'Incorrect challenge tag of ch2013wk51 (Multiple exposure), it should be ch2013wk52 (Reflections)', reflections[:message]

  end
end
