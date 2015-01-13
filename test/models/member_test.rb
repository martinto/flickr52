require 'test_helper'

class MemberTest < ActiveSupport::TestCase

  test 'member display name has real name' do
    member = Member.create! :nsid => '93469079@N04', :username => 'msmoooey', :member_type => '2', :real_name => 'Mandy'
    assert_equal 'Mandy', member.display_name
  end

  test 'member display name no real name' do
    member = Member.create! :nsid => '93469079@N04', :username => 'msmoooey', :member_type => '2'
    assert_equal 'msmoooey', member.display_name
  end
end
