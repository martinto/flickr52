class Challenge < ActiveRecord::Base
  has_many :weeks
  has_and_belongs_to_many :members
  has_many :photos

  validates_presence_of :year
  validates_presence_of :title
  validates_presence_of :url

  def update_from_flickr
    flickr_group = FlickrApi.new(url)
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
        member = Member.create! :nsid => m['nsid'], :username => m['username'], :icon_server => m['iconserver'], :icon_farm => m['iconfarm'], :member_type => m['membertype'], :real_name => m['realname']
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
    flickr_group = FlickrApi.new(url)
    photos = flickr_group.group_photos
    # [{"id"=>"16152566212", "owner"=>"57460915@N07", "secret"=>"8e5277be2c", "server"=>"7572", "farm"=>8, "title"=>"Old Country Roses Pattern", "ispublic"=>1, "isfriend"=>0, "isfamily"=>0, "ownername"=>"jscollins7", "dateadded"=>"1420004161", "dateupload"=>"1420004160", "datetaken"=>"2014-12-23 08:27:48", "datetakengranularity"=>"0", "datetakenunknown"=>"0", "tags"=>"ch2014wk51"}
    photos.each do |p|
      unless Photo.exists?(flickr_id: p['id'])
        photo = Photo.create! flickr_id: p['id'].to_i, secret: p['secret'], server: p['server'], farm: p['farm'],
                              title: p['title'], is_public: p['ispublic'] == 1, is_friend: p['isfriend'] == 1,
                              is_family: p['isfamily'] == 1, date_added: Time.at(p['dateadded'].to_i),
                              date_uploaded: Time.at(p['dateuploaded'].to_i), date_taken: Date.parse(p['datetaken']),
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
            member = Member.create! :nsid => m['nsid'], :username => m['username'], :icon_server => m['iconserver'], :icon_farm => m['iconfarm'], :member_type => 0, :real_name => m['realname']
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
end
