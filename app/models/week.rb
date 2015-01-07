class Week < ActiveRecord::Base
  belongs_to :challenge
  has_many :photos

  def date_range
    year = self.challenge.year.year
    start_week = week_number - 1
    start_date = start_week.weeks.since(Time.gm(year))
    end_date = week_number.weeks.since(Time.gm(year))
    { :start_date => start_date, :end_date => end_date }
  end
end
