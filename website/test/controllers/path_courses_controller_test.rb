require 'test_helper'

class PathCoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @path_course = path_courses(:one)
  end

  test "should get index" do
    get path_courses_url
    assert_response :success
  end

  test "should get new" do
    get new_path_course_url
    assert_response :success
  end

  test "should create path_course" do
    assert_difference('PathCourse.count') do
      post path_courses_url, params: { path_course: { course_id: @path_course.course_id, course_term: @path_course.course_term, path_id: @path_course.path_id, year: @path_course.year } }
    end

    assert_redirected_to path_course_url(PathCourse.last)
  end

  test "should show path_course" do
    get path_course_url(@path_course)
    assert_response :success
  end

  test "should get edit" do
    get edit_path_course_url(@path_course)
    assert_response :success
  end

  test "should update path_course" do
    patch path_course_url(@path_course), params: { path_course: { course_id: @path_course.course_id, course_term: @path_course.course_term, path_id: @path_course.path_id, year: @path_course.year } }
    assert_redirected_to path_course_url(@path_course)
  end

  test "should destroy path_course" do
    assert_difference('PathCourse.count', -1) do
      delete path_course_url(@path_course)
    end

    assert_redirected_to path_courses_url
  end
end
