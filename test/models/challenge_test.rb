require 'test_helper'

class ChallengeTest < ActiveSupport::TestCase

  def setup
    @challenge = Challenge.create! :year => Date.parse('2013-01-01'), :title => 'Challenge 2013', :url => 'http://www.flickr.com/groups/challenge2013/'
    @challenge.weeks << Week.create!(:week_number => 1, :subject => 'Silhouettes')
    @challenge.weeks << Week.create!(:week_number => 2, :subject => 'Self portraits')
    @challenge.weeks << Week.create!(:week_number => 3, :subject => 'Mono')
    @challenge.weeks << Week.create!(:week_number => 4, :subject => 'Looking up/down')
    @challenge.weeks << Week.create!(:week_number => 5, :subject => 'Slow shutter')
    @challenge.weeks << Week.create!(:week_number => 6, :subject => 'Strangers /Candids')
    @challenge.weeks << Week.create!(:week_number => 7, :subject => 'Doors')
    @challenge.weeks << Week.create!(:week_number => 8, :subject => 'Abstracts')
    @challenge.weeks << Week.create!(:week_number => 9, :subject => 'Still life')
    @challenge.weeks << Week.create!(:week_number => 10, :subject => 'Contrasts')
    @challenge.weeks << Week.create!(:week_number => 11, :subject => 'Within a 15 minute walk from your house')
    @challenge.weeks << Week.create!(:week_number => 12, :subject => 'Minimalism')
    @challenge.weeks << Week.create!(:week_number => 13, :subject => 'Your version of a famous photo or painting')
    @challenge.weeks << Week.create!(:week_number => 14, :subject => '35mm (or other fixed focal length)')
    @challenge.weeks << Week.create!(:week_number => 15, :subject => 'Night photography')
    @challenge.weeks << Week.create!(:week_number => 16, :subject => 'Fences')
    @challenge.weeks << Week.create!(:week_number => 17, :subject => 'Use software to create a composite')
    @challenge.weeks << Week.create!(:week_number => 18, :subject => 'Portraits')
    @challenge.weeks << Week.create!(:week_number => 19, :subject => 'A photo of the same subject for 7days')
    @challenge.weeks << Week.create!(:week_number => 20, :subject => 'Blur')
    @challenge.weeks << Week.create!(:week_number => 21, :subject => 'Holes')
    @challenge.weeks << Week.create!(:week_number => 22, :subject => 'Ice')
    @challenge.weeks << Week.create!(:week_number => 23, :subject => 'Panning')
    @challenge.weeks << Week.create!(:week_number => 24, :subject => 'Architecture')
    @challenge.weeks << Week.create!(:week_number => 25, :subject => 'Body parts ( keep it clean folks ;)')
    @challenge.weeks << Week.create!(:week_number => 26, :subject => 'Textures')
    @challenge.weeks << Week.create!(:week_number => 27, :subject => 'Wildlife')
    @challenge.weeks << Week.create!(:week_number => 28, :subject => 'Transport')
    @challenge.weeks << Week.create!(:week_number => 29, :subject => 'Friendship')
    @challenge.weeks << Week.create!(:week_number => 30, :subject => 'Trees')
    @challenge.weeks << Week.create!(:week_number => 31, :subject => 'Flash photography')
    @challenge.weeks << Week.create!(:week_number => 32, :subject => 'Food/Edibles/Consumables/ Beverages')
    @challenge.weeks << Week.create!(:week_number => 33, :subject => 'Something spotty/dotty')
    @challenge.weeks << Week.create!(:week_number => 34, :subject => 'Macro')
    @challenge.weeks << Week.create!(:week_number => 35, :subject => 'People at work')
    @challenge.weeks << Week.create!(:week_number => 36, :subject => 'Forced perspective')
    @challenge.weeks << Week.create!(:week_number => 37, :subject => 'As seen on TV')
    @challenge.weeks << Week.create!(:week_number => 38, :subject => 'Symmetry')
    @challenge.weeks << Week.create!(:week_number => 39, :subject => 'A shape (round, square, etc)')
    @challenge.weeks << Week.create!(:week_number => 40, :subject => 'Panorama')
    @challenge.weeks << Week.create!(:week_number => 41, :subject => 'Water')
    @challenge.weeks << Week.create!(:week_number => 42, :subject => 'Landscape')
    @challenge.weeks << Week.create!(:week_number => 43, :subject => 'High contrast')
    @challenge.weeks << Week.create!(:week_number => 44, :subject => 'Colour')
    @challenge.weeks << Week.create!(:week_number => 45, :subject => 'Fire')
    @challenge.weeks << Week.create!(:week_number => 46, :subject => 'Tilt shift')
    @challenge.weeks << Week.create!(:week_number => 47, :subject => 'Bridges')
    @challenge.weeks << Week.create!(:week_number => 48, :subject => 'Benches or places to sit')
    @challenge.weeks << Week.create!(:week_number => 49, :subject => 'Zoom burst')
    @challenge.weeks << Week.create!(:week_number => 50, :subject => 'Lightpainting')
    @challenge.weeks << Week.create!(:week_number => 51, :subject => 'Multiple exposure')
    @challenge.weeks << Week.create!(:week_number => 52, :subject => 'Reflections')
    @challenge.save!
  end

  test 'update from flickr' do
    @challenge.update_from_flickr
    assert_equal 39, @challenge.members.count
    assert_equal 23, @challenge.members.where('member_type != 0').count
    assert_equal 1303, @challenge.photos.count
  end

  test 'topic for week' do
    assert_equal 'Looking up/down', @challenge.topic(4)
    assert_equal 'Flash photography', @challenge.topic(31)
  end

  test 'check photos' do
    @challenge.update_from_flickr
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
