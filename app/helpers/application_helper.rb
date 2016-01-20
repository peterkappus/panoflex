module ApplicationHelper

  def is_admin?
    session['name'] = 'Peter Kappus'
  end
end
