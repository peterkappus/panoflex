class Group < ActiveRecord::Base
  has_many :roles
  has_many :teams
  #why doesn't this work?
  #scope :vacancies, -> {roles.vacant}

  #but this works...
  def vacancies
    roles.vacant
  end
  
end
