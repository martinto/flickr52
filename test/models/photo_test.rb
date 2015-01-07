require 'test_helper'

class PhotoTest < ActiveSupport::TestCase

  def setup
    @photo = Photo.create! flickr_id: 16152566212, secret: "8e5277be2c",
                          title: "Old Country Roses Pattern", is_public: true,
                          is_family: false, date_added: Time.at(1420004161),
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

end
