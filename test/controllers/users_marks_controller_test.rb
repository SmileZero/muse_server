require 'test_helper'

class UsersMarksControllerTest < ActionController::TestCase
  setup do
    @users_mark = users_marks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users_marks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create users_mark" do
    assert_difference('UsersMark.count') do
      post :create, users_mark: { mark: @users_mark.mark, music_id: @users_mark.music_id, user_id: @users_mark.user_id }
    end

    assert_redirected_to users_mark_path(assigns(:users_mark))
  end

  test "should show users_mark" do
    get :show, id: @users_mark
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @users_mark
    assert_response :success
  end

  test "should update users_mark" do
    patch :update, id: @users_mark, users_mark: { mark: @users_mark.mark, music_id: @users_mark.music_id, user_id: @users_mark.user_id }
    assert_redirected_to users_mark_path(assigns(:users_mark))
  end

  test "should destroy users_mark" do
    assert_difference('UsersMark.count', -1) do
      delete :destroy, id: @users_mark
    end

    assert_redirected_to users_marks_path
  end
end
