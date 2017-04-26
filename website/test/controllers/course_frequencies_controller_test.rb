require 'test_helper'

class CourseFrequenciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course_frequency = course_frequencies(:one)
  end

  test "should get index" do
    get course_frequencies_url
    assert_response :success
  end

  test "should get new" do
    get new_course_frequency_url
    assert_response :success
  end

  test "should create course_frequency" do
    assert_difference('CourseFrequency.count') do
      post course_frequencies_url, params: { course_frequency: { frequency: @course_frequency.frequency } }
    end

    assert_redirected_to course_frequency_url(CourseFrequency.last)
  end

  test "should show course_frequency" do
    get course_frequency_url(@course_frequency)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_frequency_url(@course_frequency)
    assert_response :success
  end

  test "should update course_frequency" do
    patch course_frequency_url(@course_frequency), params: { course_frequency: { frequency: @course_frequency.frequency } }
    assert_redirected_to course_frequency_url(@course_frequency)
  end

  test "should destroy course_frequency" do
    assert_difference('CourseFrequency.count', -1) do
      delete course_frequency_url(@course_frequency)
    end

    assert_redirected_to course_frequencies_url
  end
end
