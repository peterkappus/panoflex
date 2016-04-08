class ApplicationController < ActionController::Base

  #can't reach host: http://static.dev.gov.uk/templates/core_layout.html.erb
  #don't know how to get to dev.gov.uk....
  #include Slimmer::SharedTemplates

  #export our helper method
  helper_method :is_admin?, :signed_in?, :current_user

  #don't do this anymore, use gdsdash as a sandbox :)
  #before_filter :redirect_from_original_domain
  before_filter :check_login

  #not doing this anymore...
  #http_basic_authenticate_with (name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'])

  def is_admin?
    # TODO:  make this less dumb. Config file? Someday a database thing?
    # Peter, Poss, Pat, John, Alex, Alex... and our test user (Testy McTesterton)
    #Allow ANYONE in the sandbox to be an admin. Watch out!
    (!current_user.nil? && (ENV['IS_SANDBOX'] ||  current_user.name.match(/mctesterton|kappus|apostolou|boguzas|maddison|peart|holmes/i)))
  end

  def check_admin
    redirect_to login_path unless is_admin?
  end

  def signed_in?
    !session['user_uid'].to_s.empty?
    #!current_user.nil?
  end

  def check_login
    #raise session['email'].to_s.empty?.to_s
    if !signed_in?
      redirect_to '/auth/google_oauth2'
      return
    end
  end

  def current_user
    User.find_by(:uid=>session['user_uid'])
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
