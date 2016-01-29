class Group < ActiveRecord::Base
  has_many :roles, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :goals, dependent: :destroy

  #better as a scope?
  def vacancies
    roles.vacant
  end

  def unique_numbers
    roles.collect{|r| r.staff_number}.uniq
  end
end
