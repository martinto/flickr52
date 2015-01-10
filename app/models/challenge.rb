class Challenge < ActiveRecord::Base
  has_many :weeks
  has_and_belongs_to_many :members
  has_many :photos

  validates_presence_of :year
  validates_presence_of :title
  validates_presence_of :url

  def update_from_flickr
    flickr_group = FlickrApi.new(url)
    update_group_members(flickr_group)
    update_group_photo_data(flickr_group)
  end

  def update_group_members(flickr_group)
    if self.flickr_id.nil?
      self.flickr_id = flickr_group.group_info['id']
      save!
    end

    # Now update the list of group members.
    group_members = flickr_group.group_members
    # {"nsid"=>"93469079@N04", "username"=>"msmoooey", "iconserver"=>"7406", "iconfarm"=>8, "membertype"=>"2", "realname"=>"Mandy"}
    group_members.each do |m|
      member = nil
      if Member.exists?(nsid: m['nsid'])
        member = Member.find_by_nsid m['nsid']
      else
        member = Member.create! :nsid => m['nsid'], :username => m['username'], :member_type => m['membertype'], :real_name => m['realname']
      end
      # Does this challenge include this member?
      unless self.members.find_by_nsid(member.nsid)
        # It doesn't, so add it.
        self.members << member
        save!
      end
    end
  end

  def flickr_check_photos
    wrong_year = Array.new
    wrong_tag = Array.new
    no_tag = Array.new
    topics = topic_list
    photos.each do |p|
      # Add code for if this error has been dealt with. (next)
      unless p.taken_in_year?(year.year)
        wrong_year << { photo: p, message: "'#{p.title}' was taken in #{p.date_taken.year} for the #{year.year} challenge", url: p.get_flickr_url }
      else
        # Now check that the tag matches the year and the week.
        correct_week_tag = "ch#{year.year}wk#{p.week_number}"
        week_tag = ''
        tag_week_no = false
        p.tags.split(/\s/).each do |tag|
          if match_data = /(ch#{year.year}wk)(\d+)/.match(tag)
            week_tag = match_data[1] + match_data[2]
            tag_week_no = match_data[2]
          end
        end
        if week_tag.empty?
          no_tag << { photo: p, message: "No challenge tag, it should be #{correct_week_tag} (#{topics[p.week_number]})", url: p.get_flickr_url }
        elsif week_tag != correct_week_tag
          tagged_topic = topics[tag_week_no.to_i]
          wrong_tag << { photo: p,  message: "Incorrect challenge tag of #{week_tag} (#{tagged_topic}), it should be #{correct_week_tag} (#{topics[p.week_number]})", url: p.get_flickr_url }
        end
      end
    end
    { wrong_year: wrong_year, no_tag: no_tag, wrong_tag: wrong_tag }
  end

  def update_group_photo_data(flickr_group)
    photos = flickr_group.group_photos
    # [{"id"=>"16152566212", "owner"=>"57460915@N07", "secret"=>"8e5277be2c", "server"=>"7572", "farm"=>8, "title"=>"Old Country Roses Pattern", "ispublic"=>1, "isfriend"=>0, "isfamily"=>0, "ownername"=>"jscollins7", "dateadded"=>"1420004161", "dateupload"=>"1420004160", "datetaken"=>"2014-12-23 08:27:48", "datetakengranularity"=>"0", "datetakenunknown"=>"0", "tags"=>"ch2014wk51"}
    photos.each do |p|
      if Photo.exists?(flickr_id: p['id'])
        # Update the entry.
        photo = Photo.find_by_flickr_id p['id']
        unless photo
          EventLog.create! when: Time.now, message: "Unable to find photo #{p['id']}"
        else
          unless same_photo_data?(p, photo)
            photo.secret = p['secret']
            photo.title = p['title']
            photo.is_public = p['ispublic'] == 1
            photo.date_added = Time.at(p['dateadded'].to_i)
            photo.date_uploaded = Time.at(p['dateuploaded'].to_i)
            photo.date_taken = Time.parse(p['datetaken'])
            photo.date_taken_granularity = p['datetakengranularity'].to_i
            photo.tags = p['tags']
            photo.save!
          end
        end
      else
        photo = Photo.create! flickr_id: p['id'].to_i, secret: p['secret'],
                              title: p['title'], is_public: p['ispublic'] == 1,
                              date_added: Time.at(p['dateadded'].to_i),
                              date_uploaded: Time.at(p['dateuploaded'].to_i), date_taken: Time.parse(p['datetaken']),
                              date_taken_granularity: p['datetakengranularity'].to_i, tags: p['tags']
        self.photos << photo
        if photo.taken_in_year?(year.year)
          week = Week.where(challenge_id: id, week_number: photo.week_number).first
          if week
            week.photos << photo
          else
            EventLog.create! when: Time.now, message: "Adding photos: week not found for photo #{photo.flickr_id} challenge #{id} week #{photo.week}"
          end
        else
          EventLog.create! when: Time.now, message: "Adding photos: photo #{photo.flickr_id} was taken on #{photo.date_taken.to_date.to_formatted_s(:rfc822)} which isn't in the year #{year.year}"
        end
        member = Member.find_by_nsid p['owner']
        if member
          member.photos << photo
        else
          m = FlickrApi.person(p['owner'])
          if m
            member = Member.create! :nsid => m['nsid'], :username => m['username'], :member_type => 0, :real_name => m['realname']
            self.members << member # Must have been a member at some point.
            member.photos << photo
          else
            EventLog.create! when: Time.now, message: "Adding photos: member not found for photo #{photo.flickr_id} challenge #{id} nsid #{p['owner']}"
          end
        end
        photo.save!
      end
    end
  end

  def topic(week_number)
    week = Week.where(challenge_id: self.id, week_number: week_number).first
    return week.subject
  end

  private

  def same_photo_data?(p, photo)
    (p['secret'] == photo.secret) &&
        (p['title'] == photo.title) &&
        ((p['ispublic'] == 1) == photo.is_public) &&
        (Time.at(p['dateadded'].to_i) == photo.date_added) &&
        (Time.at(p['dateuploaded'].to_i) == photo.date_uploaded) &&
        (Time.parse(p['datetaken']) == photo.date_taken) &&
        (p['datetakengranularity'].to_i == photo.date_taken_granularity) &&
        (p['tags'] == photo.tags)
  end

  def topic_list
    result = Array.new
    weeks.each do |week|
      result[week.week_number] = week.subject
    end
    return result
  end
end
