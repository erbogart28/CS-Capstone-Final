require 'test_helper'

class WhenIfsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @when_if = when_ifs(:one)
  end

  test "should get index" do
    get when_ifs_url
    assert_response :success
  end

  test "should get new" do
    get new_when_if_url
    assert_response :success
  end

  test "should create when_if" do
    assert_difference('WhenIf.count') do
      post when_ifs_url, params: { when_if: {  } }
    end

    assert_redirected_to when_if_url(WhenIf.last)
  end

  test "should show when_if" do
    get when_if_url(@when_if)
    assert_response :success
  end

  test "should get edit" do
    get edit_when_if_url(@when_if)
    assert_response :success
  end

  test "should update when_if" do
    patch when_if_url(@when_if), params: { when_if: {  } }
    assert_redirected_to when_if_url(@when_if)
  end

  test "should destroy when_if" do
    assert_difference('WhenIf.count', -1) do
      delete when_if_url(@when_if)
    end

    assert_redirected_to when_ifs_url
  end
end
