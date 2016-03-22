class ApplicationController < ActionController::Base

  #can't reach host: http://static.dev.gov.uk/templates/core_layout.html.erb
  #don't know how to get to dev.gov.uk.... 
  #include Slimmer::SharedTemplates

  #export our helper method
  helper_method :is_admin?

  before_filter :redirect_from_original_domain
  before_filter :check_login

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

  def check_login
    redirect_to login_path unless session['email']
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  #redirect from the old heroku URL to the new one
  def redirect_from_original_domain
    if request.host.match(/gdsdash.herokuapp.com/)
      redirect_to "http://gdsdelivery.herokuapp.com"
    end
  end
end
