class SessionsController < ApplicationController

  skip_before_action :check_login

  def new
    #if we're in the test environment and attempt to login using oAuth, just create a new session. Make this smarter when you actually want to test different kinds of users and when users actually exist in the database.
    if Rails.env.test?
      session['email'] = 'tester@digital.cabinet-office.gov.uk'
      session['name'] = 'Testy McTesterton'
      #flash['notice'] = 'Welcome ' & session['name']
      #redirct_to root_path
    end
    #for some reason, I couldn't just call my check_login function...
    #if not logged in, redirect to google auth
    if session['email'].to_s.empty?
      redirect_to '/auth/google_oauth2'
      return
    end
    #otherwise, redirect home and say already logged in
    flash['notice'] = "Already logged in as " + session['name']
    redirect_to root_path
  end

  def create
    #raise env["omniauth.auth"].info['name']
    if(env["omniauth.auth"].info['email'].match(/@digital.cabinet-office.gov.uk$/) || env["omniauth.auth"].info['email'].match(/@cabinetoffice.gov.uk$/))
      session['name'] = env["omniauth.auth"].info['name']
      session['email'] = env["omniauth.auth"].info['email']
      flash['notice'] = "Successfully signed in as " + session['name']
    else
      flash['error'] = "Sorry, you must have a GDS or Cabinet Office email address to login."
    end
    redirect_to root_path
  end

  def handle_failure
    flash['error'] = "Sorry, the authentication service returned the following error: " + params['message']
    session['name'] = session['email'] = nil
    redirect_to root_path
  end

  def destroy
    session['name'] = session['email'] = nil
    flash['notice'] = "Logged out"
    redirect_to "/"
  end

end
