class SessionsController < ApplicationController

  skip_before_action :check_login

  def new
    if !signed_in?
      #if we're in the test environment and attempt to login using oAuth, just create a new session. Make this smarter when you actually want to test different kinds of users and when users actually exist in the database.

      if ((Rails.env.test? || Rails.env.development?) && params['email'].present?)
        #create this user in the step definition
        if(user = User.find_by_email(params['email']))
          session['user_email'] = user.email
          flash['notice'] = "Successfully signed in as " + user.name.to_s
        else
          flash['error'] = "Could not find test user with email " + params['email'].to_s
        end
        redirect_to root_path
        return
      else
      #for some reason, I couldn't just call my check_login function...
      #if not logged in, redirect to google auth
        redirect_to '/auth/google_oauth2'
        return
      end
    else
      #otherwise, redirect home and say already logged in
      flash['notice'] = "Already logged in as " + current_user.name
      redirect_to root_path
    end
  end

  def create
    if(env["omniauth.auth"].info['email'].match(/cabinet-office\.gov\.uk|parliament\.uk|digital\.cabinet-office\.gov\.uk$/))
      user = User.find_or_create_by(:email=>env["omniauth.auth"].info['email'])
      user.name = env["omniauth.auth"].info['name']
      #user.email = env["omniauth.auth"].info['email']
      user.save!
      session['user_email'] = user.email
      flash['notice'] = "Successfully signed in as " + user.name
    else
      flash['error'] = "Sorry, you must have a GDS or Cabinet Office email address to login."
    end
    redirect_to root_path
  end

  def handle_failure
    flash['error'] = "Sorry, the authentication service returned the following error: " + params['message']
    session['user_email'] = nil
    redirect_to root_path
  end

  def destroy
    session['user_email'] = "" #assigning to nil didn't work...
    flash['notice'] = "Successfully signed out."
    redirect_to "/"
  end

end
