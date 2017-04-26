require 'test_helper'

class CourseDeliveriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course_delivery = course_deliveries(:one)
  end

  test "should get index" do
    get course_deliveries_url
    assert_response :success
  end

  test "should get new" do
    get new_course_delivery_url
    assert_response :success
  end

  test "should create course_delivery" do
    assert_difference('CourseDelivery.count') do
      post course_deliveries_url, params: { course_delivery: { course_frequency: @course_delivery.course_frequency, course_id: @course_delivery.course_id, course_term: @course_delivery.course_term } }
    end

    assert_redirected_to course_delivery_url(CourseDelivery.last)
  end

  test "should show course_delivery" do
    get course_delivery_url(@course_delivery)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_delivery_url(@course_delivery)
    assert_response :success
  end

  test "should update course_delivery" do
    patch course_delivery_url(@course_delivery), params: { course_delivery: { course_frequency: @course_delivery.course_frequency, course_id: @course_delivery.course_id, course_term: @course_delivery.course_term } }
    assert_redirected_to course_delivery_url(@course_delivery)
  end

  test "should destroy course_delivery" do
    assert_difference('CourseDelivery.count', -1) do
      delete course_delivery_url(@course_delivery)
    end

    assert_redirected_to course_deliveries_url
  end
end
