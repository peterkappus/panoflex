class SessionsController < ApplicationController

  skip_before_action :check_login

  def new
    if !signed_in?
      #if we're in the test environment and attempt to login using oAuth, just create a new session. Make this smarter when you actually want to test different kinds of users and when users actually exist in the database.
      if Rails.env.test?
        user = User.find_or_create_by(:email=>'tester@digital.cabinet-office.gov.uk')
        user.name = 'Testy McTesterton'
        user.uid = 'this-is-a-really-funny-uid-for-my-test-user'
        user.save!
        session['user_uid'] = user.uid
        flash['notice'] = 'Successfully signed in as ' + user.name
        redirect_to root_path
      else
      #for some reason, I couldn't just call my check_login function...
      #if not logged in, redirect to google auth
        redirect_to '/auth/google_oauth2'
        return
      end
    else
      #otherwise, redirect home and say already logged in
      flash['notice'] = "Already logged in as " + session['user'].name
      redirect_to root_path
    end
  end

  def create
    #raise env["omniauth.auth"].info['name']
    if(env["omniauth.auth"].info['email'].match(/@digital.cabinet-office.gov.uk$/) || env["omniauth.auth"].info['email'].match(/@cabinetoffice.gov.uk$/))
      user = User.find_or_create_by(:uid=>env["omniauth.auth"].info['uid'])
      user.name = env["omniauth.auth"].info['name']
      user.email = env["omniauth.auth"].info['email']
      user.save!
      session['user_uid'] = user.uid
      flash['notice'] = "Successfully signed in as " + user.name + user.uid
    else
      flash['error'] = "Sorry, you must have a GDS or Cabinet Office email address to login."
    end
    redirect_to root_path
  end

  def handle_failure
    flash['error'] = "Sorry, the authentication service returned the following error: " + params['message']
    session['user_uid'] = nil
    redirect_to root_path
  end

  def destroy
    session['user_uid'] = "" #assigning to nil didn't work...
    flash['notice'] = "Logged out"
    redirect_to "/"
  end

end
