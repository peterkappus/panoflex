class Group < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true
  has_many :roles, dependent: :destroy
  has_many :teams, -> {order 'name'}, dependent: :destroy
  has_many :goals, dependent: :destroy

  monetize :budget_pennies, :as=>:budget

  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  #has_many :top_level_goals, -> {goals.where("parent_id is null")}
  #has_many :top_level, -> { where("parent_id is null").order('created_at DESC') },  dependent: :destroy

  def goals_without_a_team
    goals.where("team_id is null")
  end

  def top_level_goals
    goals.where("parent_id is null")
  end

  def budget_in_millions
    (budget.to_f/1000000).round(1)
  end
  
  #better as a scope?
  def vacancies
    roles.vacant
  end

  def unique_numbers
    roles.collect{|r| r.staff_number}.uniq
  end
end
