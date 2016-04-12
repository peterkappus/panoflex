class Group < ActiveRecord::Base
  #default to order by budget size descending
  default_scope{ order('budget_pennies DESC') }
  validates :name, uniqueness: true, presence: true
  has_many :roles, dependent: :destroy
  has_many :teams, -> {order 'name'}, dependent: :destroy
  has_many :goals, dependent: :destroy

  monetize :budget_pennies, :as=>:budget

  #attr_accessible :budget_in_millions

  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  #has_many :top_level_goals, -> {goals.where("parent_id is null")}
  #has_many :top_level, -> { where("parent_id is null").order('created_at DESC') },  dependent: :destroy

  def goals_without_a_team
    goals.where("team_id is null")
  end

  def budget_in_millions=(how_much)
    #cast as float or else get one million copies of the how_much string :)
    self.budget = how_much.to_f * 1000000
  end

  def budget_in_millions
    (self.budget.to_f/1000000).round(1)
  end

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
