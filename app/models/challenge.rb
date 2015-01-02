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
end
