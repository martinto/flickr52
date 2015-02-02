require 'test_helper'

class SentEmailsControllerTest < ActionController::TestCase
  setup do
    @sent_email = sent_emails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sent_emails)
  end

  test "should show sent_email" do
    get :show, id: @sent_email
    assert_response :success
  end

end
