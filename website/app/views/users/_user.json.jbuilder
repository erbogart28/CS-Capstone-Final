json.extract! user, :id, :username, :password, :permission, :view_as, :first, :last, :email, :degree_id, :course_load, :in_class, :online, :path_id, :deleted, :created_at, :updated_at
json.url user_url(user, format: :json)
