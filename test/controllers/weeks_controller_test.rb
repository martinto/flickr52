require 'test_helper'

class WeeksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index, :challenge_id => 1
    assert_response :success
    assert_not_nil assigns(:weeks)
  end

  test "should get new" do
    get :new, :challenge_id => 1
    assert_response :success
  end

  test "should create week" do
    assert_difference('Week.count') do
      post :create, :challenge_id => 1, week: { subject: 'Something', week_number: 25 }
    end

    assert_redirected_to challenge_week_path(1, assigns(:week))
  end

  test "should show week" do
    get :show, :challenge_id => 1, id: 1
    assert_response :success
  end

  test "should get edit" do
    get :edit, :challenge_id => 1, id: 1
    assert_response :success
  end

  test "should update week" do
    patch :update, :challenge_id => 1, id: 1, week: { subject: 'Something', week_number: 25 }
    assert_redirected_to challenge_week_path(1, assigns(:week))
  end

  test "should destroy week" do
    assert_difference('Week.count', -1) do
      delete :destroy, :challenge_id => 1, id: 1
    end

    assert_redirected_to challenge_weeks_path
  end
end
