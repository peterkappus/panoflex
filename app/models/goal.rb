class Goal < ActiveRecord::Base
  belongs_to :team
  belongs_to :group
  has_many :children, :class_name=>'Goal', :foreign_key=>'parent_id', dependent: :nullify
  # don't use, dependent: :destroy because it's better to orphan goals when the parent is deleted so that they can be re-assigned at some point and we don't lose history. TODO: create a way to archive goals instead of destroying them if thye're no longer "active".

  belongs_to :parent, :class_name=>'Goal', :foreign_key=>'parent_id'

  # TODO: validation...
  # group goals must have a parent GDS goal
  # GDS goals must NOT have any parent goals
  # GDS goals must NOT belong to a group or a team
  # team goals must have a parent goal which belongs to a group
  scope :gds_goals, -> {where("parent_id is null")}

  def group_name
    group.nil? ? "" : group.name
  end

  def owner_name
      (owner) ? owner.name + " " + owner.class.name : ""
  end

  def owner
    team || group
  end

  def team_name
    team.nil? ? "" : team.name
  end

  def parent_goal_name
    parent_goal.nil? ? "" : parent_goal.name
  end
end
