class Goal < ActiveRecord::Base
  belongs_to :team
  belongs_to :group
  has_many :children, :class_name=>'Goal', :foreign_key=>'parent_id', dependent: :nullify
  has_many :scores, -> { order('created_at DESC') },  dependent: :destroy

  # don't use, dependent: :destroy ... better to orphan goals when the parent is deleted so that they can be re-assigned at some point and we don't lose history. TODO: create a way to archive goals instead of destroying them if thye're no longer "active". Ditto for scores...

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

  def current_amount
    #use the real score if we have one, otherwise assume zero
    #could make this more sophistocated later (e.g. use #N/A)

    #if we don't have child goals, use the current manual score
    #if there isn't a manually entered score, use zero
    #if we DO have children, average up the child scores
    #this should recursively follow all children to the bottom...
    #could be VERY slow with lots of kids... might want to make this an offline process and save the score inside the Goal model... TODO
    if(children.empty?)
      score ? score.amount : 0
    else
      children.map{|c| c.current_amount}.inject(:+).to_f / children.count
    end
  end

  def display_amount
    current_amount.to_i.to_s + "%"
  end

  def current_display_date
    #TODO make this smarter, needs to take the most recent score date from the children in a similar way to how we get the current amount above..
    score ? score.display_date : "Never scored"
  end

  def score
    scores.first
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
