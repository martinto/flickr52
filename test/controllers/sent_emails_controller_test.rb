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

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sent_email" do
    assert_difference('SentEmail.count') do
      post :create, sent_email: { error_type: @sent_email.error_type, message: @sent_email.message, photo: @sent_email.photo, sent_at: @sent_email.sent_at, title: @sent_email.title }
    end

    assert_redirected_to sent_email_path(assigns(:sent_email))
  end

  test "should show sent_email" do
    get :show, id: @sent_email
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sent_email
    assert_response :success
  end

  test "should update sent_email" do
    patch :update, id: @sent_email, sent_email: { error_type: @sent_email.error_type, message: @sent_email.message, photo: @sent_email.photo, sent_at: @sent_email.sent_at, title: @sent_email.title }
    assert_redirected_to sent_email_path(assigns(:sent_email))
  end

  test "should destroy sent_email" do
    assert_difference('SentEmail.count', -1) do
      delete :destroy, id: @sent_email
    end

    assert_redirected_to sent_emails_path
  end
end
