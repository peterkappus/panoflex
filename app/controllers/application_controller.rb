class ApplicationController < ActionController::Base
  if(ENV['BASIC_AUTH_USERNAME'].to_s.empty? || ENV['BASIC_AUTH_PASSWORD'].to_s.empty?)
    raise "BASIC_AUTH_USERNAME and/or BASIC_AUTH_PASSWORD not set (or exported) in ENV. Please set & export these and try again."
  end
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD']
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
