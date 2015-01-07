require 'test_helper'

class WeekTest < ActiveSupport::TestCase
  test 'date range week 1' do
    challenge = Challenge.create! :year => DateTime.parse('2014-01-01'), :title => 'Challenge 2014', :url => 'http://www.flickr.com/groups/challenge2014/'
    week = Week.create! :week_number => 1, :subject => 'something'
    challenge.weeks << week
    challenge.save!

    dates = week.date_range

    assert_equal Date.parse('2014-01-01'), dates[:start_date]
    assert_equal Date.parse('2014-01-08'), dates[:end_date]
  end

  test 'date range week 52' do
    challenge = Challenge.create! :year => DateTime.parse('2014-01-01'), :title => 'Challenge 2014', :url => 'http://www.flickr.com/groups/challenge2014/'
    week = Week.create! :week_number => 52, :subject => 'something'
    challenge.weeks << week
    challenge.save!

    dates = week.date_range

    assert_equal Date.parse('2014-12-24'), dates[:start_date]
    assert_equal Date.parse('2014-12-31'), dates[:end_date]
  end
end
