class WelcomeController < ApplicationController
  skip_before_filter :check_login, :except => [:about]

  def index
    if signed_in?
      redirect_to goals_path
    end
  end

end
