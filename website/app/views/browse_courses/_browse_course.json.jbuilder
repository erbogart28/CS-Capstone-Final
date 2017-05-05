json.extract! browse_course, :id, :course_code, :name, :description, :created_at, :updated_at
json.url browse_course_url(browse_course, format: :json)
