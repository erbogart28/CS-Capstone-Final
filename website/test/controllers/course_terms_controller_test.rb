require 'test_helper'

class CourseTermsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course_term = course_terms(:one)
  end

  test "should get index" do
    get course_terms_url
    assert_response :success
  end

  test "should get new" do
    get new_course_term_url
    assert_response :success
  end

  test "should create course_term" do
    assert_difference('CourseTerm.count') do
      post course_terms_url, params: { course_term: { term: @course_term.term } }
    end

    assert_redirected_to course_term_url(CourseTerm.last)
  end

  test "should show course_term" do
    get course_term_url(@course_term)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_term_url(@course_term)
    assert_response :success
  end

  test "should update course_term" do
    patch course_term_url(@course_term), params: { course_term: { term: @course_term.term } }
    assert_redirected_to course_term_url(@course_term)
  end

  test "should destroy course_term" do
    assert_difference('CourseTerm.count', -1) do
      delete course_term_url(@course_term)
    end

    assert_redirected_to course_terms_url
  end
end
