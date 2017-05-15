class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  #can't reach host: http://static.dev.gov.uk/templates/core_layout.html.erb
  #don't know how to get to dev.gov.uk....
  #include Slimmer::SharedTemplates

  #export our helper method
  helper_method :is_admin?, :signed_in?, :current_user, :can_modify?, :can_destroy?

  #don't do this anymore, use gdsdash as a sandbox :)
  #before_filter :redirect_from_original_domain

  before_filter :check_login

  #not doing this anymore...
  #http_basic_authenticate_with (name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'])

  #NOTE: this is being relaxed so that anyone can modify a goal... but only the owner can destroy it.
  def can_modify?(goal)
    is_admin? || current_user == goal.owner
  end


  # To be more specific
  def can_destroy?(goal)
    is_admin? || current_user == goal.owner
  end

  def can_create?(parent_goal)
    if parent_goal.nil?
      is_admin?
    else
       current_user == parent_goal.owner
    end
  end

  def is_admin?
    signed_in? && current_user.admin?
  end

  def check_admin
    if !is_admin?
      flash['error'] = "The action you've requested requires admin privileges. "
      redirect_to root_path
    end
  end

  def signed_in?
    current_user && !current_user.name.to_s.empty? && !current_user.email.to_s.empty?
  end

  def check_login
    if !signed_in?
      session[:previous_url] = request.path
      #render "welcome/index"
      redirect_to "http://www.gov.uk"

      #redirect_to '/auth/google_oauth2'
      return
    end
  end

  def current_user
    User.find_by(:email=>session['user_email'])
  end


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def record_not_found
    flash[:error] = "Sorry, could not find that team/group/person/etc. Please check the URL and try again."
    redirect_to "/"
  end
  #redirect from the old heroku URL to the new one
  def redirect_from_original_domain
    if request.host.match(/gdsdash.herokuapp.com/)
      redirect_to "http://gdsdelivery.herokuapp.com"
    end
  end
end
