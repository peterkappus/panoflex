class SessionsController < ApplicationController
  def create
    #raise env["omniauth.auth"].info['name']
    if(env["omniauth.auth"].info['email'].match(/@digital.cabinet-office.gov.uk$/))
      session['name'] = env["omniauth.auth"].info['name']
      flash['notice'] = "Successfully signed in as " + session['name']

      #don't need this yet...
      #session['email'] = env["omniauth.auth"].info['email']
    else
      flash['error'] = "Sorry, only accounts with a digital.cabinet-office.gov.uk email address may login to this system."
    end
    redirect_to root_path
  end

  def handle_failure
    flash['error'] = "Sorry, the authentication service returned the following error: " + params['message']
    session['name'] = session['email'] = nil
    redirect_to root_path
  end

  def destroy
    session['name'] = 'booger'
    flash['notice'] = "Logged out"
    redirect_to "/"
  end

end
