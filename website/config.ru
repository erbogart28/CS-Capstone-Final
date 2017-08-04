# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

begin
  require 'minitest/autorun'
rescue LoadError => e
  raise e unless ENV['RAILS_ENV'] == "production"
end

run Rails.application
