require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_new_url
    assert_response :success
  end

  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { course_load: @user.course_load, degree_id: @user.degree_id, deleted: @user.deleted, email: @user.email, first: @user.first, in_class: @user.in_class, last: @user.last, online: @user.online, password: @user.password, path_id: @user.path_id, permission: @user.permission, username: @user.username, view_as: @user.view_as } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { course_load: @user.course_load, degree_id: @user.degree_id, deleted: @user.deleted, email: @user.email, first: @user.first, in_class: @user.in_class, last: @user.last, online: @user.online, password: @user.password, path_id: @user.path_id, permission: @user.permission, username: @user.username, view_as: @user.view_as } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
