require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

  def setup
    @photo = Photo.create! flickr_id: 16152566212, secret: "8e5277be2c",
                          title: "Old Country Roses Pattern", is_public: true,
                          date_added: Time.at(1420004161),
                          date_uploaded: Time.at(1420004160), date_taken: Date.parse("2014-12-23 08:27:48"),
                          date_taken_granularity: 0, tags: "ch2014wk51"
  end

  test 'photo at start of first week' do
    @photo.date_taken = Date.parse("2014-01-01 00:00:00")
    @photo.save!
    week_no = @photo.week_number
    assert_equal 1, week_no
  end

  test 'photo at end of first week' do
    @photo.date_taken = Date.parse("2014-01-07 23:59:59")
    @photo.save!
    week_no = @photo.week_number
    assert_equal 1, week_no
  end

  test 'photo at start of second week' do
    @photo.date_taken = Date.parse("2014-01-08 00:00:00")
    @photo.save!
    week_no = @photo.week_number
    assert_equal 2, week_no
  end

  test 'photo at end of second week' do
    @photo.date_taken = Date.parse("2014-01-14 23:59:59")
    @photo.save!
    week_no = @photo.week_number
    assert_equal 2, week_no
  end

  test 'get photo url' do
    url = @photo.get_flickr_url
    assert_equal 'https://www.flickr.com/photos/johnecollins/16152566212/', url
  end

  test 'was taken in year' do
    assert @photo.taken_in_year?(2014)
  end

  test 'was not taken in year' do
    assert !@photo.taken_in_year?(2013)
    assert !@photo.taken_in_year?(2015)
  end

  test 'flickr url' do
    assert_equal 'https://www.flickr.com/photos/johnecollins/16152566212/', @photo.get_flickr_url
    assert_equal 'https://www.flickr.com/photos/johnecollins/16152566212/', @photo.flickr_url
  end

  test 'good challenge tags on their own' do
    [ 'ch2014wk1', 'ch2014wk2', 'ch2014wk51', 'ch2014wk52' ].each do |tag|
      @photo.tags = tag
      assert_equal tag, @photo.challenge_tag(2014)
    end
  end

  test 'good challenges multiple tags' do
    { 'tag1 ch2014wk1' => 'ch2014wk1', 'ch2014wk2 tag2' => 'ch2014wk2', 'before ch2014wk51 after' => 'ch2014wk51', 'askdj oer sdfs+ssd ch2014wk52 sdfsfd@345' => 'ch2014wk52' }.each_pair do |tags, tag|
      @photo.tags = tags
      assert_equal tag, @photo.challenge_tag(2014)
    end
  end

  test 'bad challenge tags on their own' do
    [ 'ch2014wk01', 'ch2013wk2', 'Ch2014wk51', 'ch2014week52', 'ch2014 wk12', 'ch2014wk123' ].each do |tag|
      @photo.tags = tag
      assert_equal '', @photo.challenge_tag(2014)
    end
  end

  test 'bad challenges multiple tags' do
    [ 'tag1 ch2014wk01', 'ch2013wk2 tag2', 'before Ch2014wk51 after', 'askdj oer sdfs+ssd ch2014week52 sdfsfd@345', 'sdfs fdg dfg ch2014wk123 dfgjdfgdf' ].each do |tags|
      @photo.tags = tags
      assert_equal '', @photo.challenge_tag(2014)
    end
  end

  test 'good week numbers in the tag' do
    { 'ch2014wk1' => '1', 'ch2014wk2' => '2', 'ch2014wk51' => '51', 'ch2014wk52' => '52' }.each_pair do |tag, week_no|
      @photo.tags = tag
      assert_equal week_no, @photo.tagged_as_week
    end
  end

end
