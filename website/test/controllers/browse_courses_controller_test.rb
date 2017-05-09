require 'test_helper'

class BrowseCoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @browse_course = browse_courses(:one)
  end

  test "should get index" do
    get browse_courses_url
    assert_response :success
  end

  test "should get new" do
    get new_browse_course_url
    assert_response :success
  end

  test "should create browse_course" do
    assert_difference('BrowseCourse.count') do
      post browse_courses_url, params: { browse_course: { course_code: @browse_course.course_code, description: @browse_course.description, name: @browse_course.name } }
    end

    assert_redirected_to browse_course_url(BrowseCourse.last)
  end

  test "should show browse_course" do
    get browse_course_url(@browse_course)
    assert_response :success
  end

  test "should get edit" do
    get edit_browse_course_url(@browse_course)
    assert_response :success
  end

  test "should update browse_course" do
    patch browse_course_url(@browse_course), params: { browse_course: { course_code: @browse_course.course_code, description: @browse_course.description, name: @browse_course.name } }
    assert_redirected_to browse_course_url(@browse_course)
  end

  test "should destroy browse_course" do
    assert_difference('BrowseCourse.count', -1) do
      delete browse_course_url(@browse_course)
    end

    assert_redirected_to browse_courses_url
  end
end
