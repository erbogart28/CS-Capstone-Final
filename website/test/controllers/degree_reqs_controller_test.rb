require 'test_helper'

class DegreeReqsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @degree_req = degree_reqs(:one)
  end

  test "should get index" do
    get degree_reqs_url
    assert_response :success
  end

  test "should get new" do
    get new_degree_req_url
    assert_response :success
  end

  test "should create degree_req" do
    assert_difference('DegreeReq.count') do
      post degree_reqs_url, params: { degree_req: { course_id: @degree_req.course_id } }
    end

    assert_redirected_to degree_req_url(DegreeReq.last)
  end

  test "should show degree_req" do
    get degree_req_url(@degree_req)
    assert_response :success
  end

  test "should get edit" do
    get edit_degree_req_url(@degree_req)
    assert_response :success
  end

  test "should update degree_req" do
    patch degree_req_url(@degree_req), params: { degree_req: { course_id: @degree_req.course_id } }
    assert_redirected_to degree_req_url(@degree_req)
  end

  test "should destroy degree_req" do
    assert_difference('DegreeReq.count', -1) do
      delete degree_req_url(@degree_req)
    end

    assert_redirected_to degree_reqs_url
  end
end
