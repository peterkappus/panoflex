class SessionsController < ApplicationController
  def create
    #raise env["omniauth.auth"].info['name']
    session['name'] = env["omniauth.auth"].info['name']
    flash['notice'] = "Logged in"
    redirect_to root_path
  end

  def destroy
    session['name'] = 'booger'
    flash['notice'] = "Logged out"
    redirect_to "/"
  end

end
