require 'test_helper'

class PrereqsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prereq = prereqs(:one)
  end

  test "should get index" do
    get prereqs_url
    assert_response :success
  end

  test "should get new" do
    get new_prereq_url
    assert_response :success
  end

  test "should create prereq" do
    assert_difference('Prereq.count') do
      post prereqs_url, params: { prereq: { course_id: @prereq.course_id, prereq_course_id: @prereq.prereq_course_id } }
    end

    assert_redirected_to prereq_url(Prereq.last)
  end

  test "should show prereq" do
    get prereq_url(@prereq)
    assert_response :success
  end

  test "should get edit" do
    get edit_prereq_url(@prereq)
    assert_response :success
  end

  test "should update prereq" do
    patch prereq_url(@prereq), params: { prereq: { course_id: @prereq.course_id, prereq_course_id: @prereq.prereq_course_id } }
    assert_redirected_to prereq_url(@prereq)
  end

  test "should destroy prereq" do
    assert_difference('Prereq.count', -1) do
      delete prereq_url(@prereq)
    end

    assert_redirected_to prereqs_url
  end
end
