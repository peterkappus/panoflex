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

  def display_deadline
    if(deadline)
      deadline.strftime("%d %h %Y")
    end
  end

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
    score ? score.display_date : ""
  end

  def score
    scores.first
  end

  def owner_name
      (owner) ? owner.name + " " + owner.class.name : ""
      #owner.name
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

  def self.import_okrs(file)
    require 'csv'
    require 'Date' #for parsing

    #DANGER! Nuke all goals before importing...
    Goal.destroy_all

    required_cols = %w(group level_2 level_3 level_4 deadline)

    #subtract supplied columns from required columns to see if any are missing
    missing_cols = required_cols - CSV.read(file.path,headers: true).headers

    if(!missing_cols.empty?)
      return "Missing columns: #{missing_cols.join(", ")}"
    else

      CSV.foreach(file.path, headers: true) do |row|
        next if row['group'] == 'n/a' || row['group'].to_s.empty?

        #find the group
        group = Group.find_by_name(row['group'].titlecase) || raise("Group: #{row['group']} not found!")

        unless row['team'].to_s.empty?
          team = Team.find_or_create_by(:name=>row['team'].to_s)
          team.group = group
          team.save!
        end

        deadline = Date.parse(row['deadline'])

        #find group objective
        level_2 = Goal.find_or_create_by(:name=>row['level_2'])
        level_2.group = group
        level_2.team = team unless team.nil?
        level_2.save!

        #did we get a group key result?
        if(!row['level_3'].to_s.empty?)
          level_3 = Goal.find_or_create_by(:name=>row['level_3'])
          level_3.parent = level_2
          level_3.group = group
          level_3.team = nil
          level_3.save!
        end

        #did we get a team_objective?
        if(!row['level_4'].to_s.empty?)
          #find or create team level objective
          level_4 = Goal.find_or_create_by(:name=>row['level_4'])
          level_4.group = group
          #set team
          level_4.team = team unless team.nil?
          level_4.parent = level_3
          level_4.save!
        end

        #must be a more efficient way to do this...
        #if we have a level 4 then apply the date to that.
        #if not, apply it to level 3, etc
        if(level_4)
          level_4.deadline = deadline
          level_4.save!
        elsif(level_3)
          level_3.deadline = deadline
          level_3.save!
        else
          level_2.deadline = deadline
          level_2.save!
        end
      end
    end
  end
end
