class Group < ActiveRecord::Base
  has_many :roles, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :goals, dependent: :destroy
  #has_many :top_level_goals, -> {goals.where("parent_id is null")}
  #has_many :top_level, -> { where("parent_id is null").order('created_at DESC') },  dependent: :destroy


  def top_level_goals
    goals.where("parent_id is null")
  end

  #better as a scope?
  def vacancies
    roles.vacant
  end

  def unique_numbers
    roles.collect{|r| r.staff_number}.uniq
  end
end
