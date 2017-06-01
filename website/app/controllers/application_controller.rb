class ApplicationController < ActionController::Base
  require 'csv'
  protect_from_forgery with: :exception
  include SessionsHelper
  impersonates :user,
               method: :current_user,
               with: -> (id) { User.find_by(id: id) }
end
