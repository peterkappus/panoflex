class ApplicationController < ActionController::Base

  #import our helper method
  helper_method :is_admin?

  def is_admin?
    # TODO:  make this less dumb. Config file? Someday a database thing?
    # Peter, Poss, Pat, John, Alex, Alex...
    session['name'] && session['name'].match(/kappus|apostolou|boguzas|maddison|peart|holmes|yedigaroff/i)
    #this would let anyone at GDS be an admin...
    #session['email'].match(/digital.cabinet-office.gov.uk/)

  end

  #basic auth stuff... remove once Google Auth is working
  if(ENV['BASIC_AUTH_USERNAME'].to_s.empty? || ENV['BASIC_AUTH_PASSWORD'].to_s.empty?)
    raise "BASIC_AUTH_USERNAME and/or BASIC_AUTH_PASSWORD not set (or exported) in ENV. Please set & export these and try again."
  end
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD']

  def check_admin
    redirect_to login_path unless is_admin?
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
