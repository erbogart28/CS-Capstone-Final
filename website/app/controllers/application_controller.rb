class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
impersonates :user,
             method: :current_user,
             with: -> (id) { User.find_by(id: id) }
end
