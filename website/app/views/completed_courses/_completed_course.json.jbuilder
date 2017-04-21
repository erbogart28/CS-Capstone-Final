json.extract! completed_course, :id, :user_id, :course_id, :created_at, :updated_at
json.url completed_course_url(completed_course, format: :json)
