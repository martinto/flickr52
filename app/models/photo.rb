class Photo < ActiveRecord::Base
  belongs_to :member
  belongs_to :challenge
  belongs_to :week

  validates_presence_of :flickr_id
  validates_numericality_of :flickr_id
  validates_presence_of :secret

  CHALLENGE_TAG_PATTERN = /^ch(\d{4})wk([1-5]\d{0,1})$/

  def week_number
    # Use date taken to work out which week this photo was taken in.
    day_of_year = date_taken.yday
    return (((day_of_year - 1) / 7).to_i) + 1
  end

  def taken_in_year?(year)
    return date_taken.year == year
  end

  def get_flickr_url
    # TODO: Get rid of this by intercepting self.flick_url
    if self.flickr_url.nil?
      photo_info = FlickrApi.photo_info(self.flickr_id, self.secret)
      self.flickr_url = photo_info['urls'][0]['_content']
      save!
    end
    return self.flickr_url
  end

  def challenge_tag(year)
    week_tag = ''
    self.tags.split(/\s/).each do |tag|
      if match_data = CHALLENGE_TAG_PATTERN.match(tag)
        next if match_data[1].to_i != year
        week_tag = 'ch' + match_data[1] + 'wk' + match_data[2]
      end
    end
    return week_tag
  end

  def tagged_as_week
    tag_week_no = false
    self.tags.split(/\s/).each do |tag|
      if match_data = CHALLENGE_TAG_PATTERN.match(tag)
        tag_week_no = match_data[2]
      end
    end
    return tag_week_no
  end

  def is_same_as?(p)
    (p['secret'] == self.secret) &&
        (p['title'] == self.title) &&
        ((p['ispublic'] == 1) == self.is_public) &&
        (Time.at(p['dateadded'].to_i) == self.date_added) &&
        (Time.at(p['dateuploaded'].to_i) == self.date_uploaded) &&
        (Time.parse(p['datetaken']) == self.date_taken) &&
        (p['datetakengranularity'].to_i == self.date_taken_granularity) &&
        (p['tags'] == self.tags)
  end

  def update_from(p)
    self.secret = p['secret']
    self.title = p['title']
    self.is_public = p['ispublic'] == 1
    self.date_added = Time.at(p['dateadded'].to_i)
    self.date_uploaded = Time.at(p['dateuploaded'].to_i)
    self.date_taken = Time.parse(p['datetaken'])
    self.date_taken_granularity = p['datetakengranularity'].to_i
    self.tags = p['tags']
    self.save!
  end

end
