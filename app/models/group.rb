class Group < ActiveRecord::Base
  has_many :roles, dependent: :destroy
  has_many :teams, dependent: :destroy
  #why doesn't this work?
  #scope :vacancies, -> {roles.vacant}

  #but this works...
  def vacancies
    roles.vacant
  end

  def unique_numbers
    roles.collect{|r| r.staff_number}.uniq
  end
end
