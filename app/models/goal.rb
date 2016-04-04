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
      (owner) ? owner.name : "" # + " " + owner.class.name : ""
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

  #determine if all the sub-goals belong to the same team...
  def get_team
    if(children.empty?)
      team
    else
      #if(children.pluck(:team_id).uniq.count == 1 && !children.pluck(:team_id).uniq.first.nil?
      #otherwise, traverse the kids, if they all have the same team (and it isn't nil) then return that. Otherwise, return nil.
      unique_child_teams = children.map{|c| c.get_team}.uniq
      if(unique_child_teams.count == 1 && !unique_child_teams.first.nil?)
        unique_child_teams.first
      end
    end
  end

  #right now this imports ALL the data into our database. Group and team names, headcount, budget, etc. should all be present in this spreadsheet. It's inefficient but an easy to completely wipe and re-import the whole DB from a single Google Spreadsheet. This process may change over time...
  def self.import_okrs(file)
    require 'csv'

    #in-memory has saves us having to do a sql lookup for every row
    groups = {}
    teams = {}
    goals = {}

    required_cols = %w(group level_2 level_3 level_4 deadline)

    #subtract supplied columns from required columns to see if any are missing
    missing_cols = required_cols - CSV.read(file.path,headers: true).headers

    if(!missing_cols.empty?)
      return "Missing columns: #{missing_cols.join(", ")}"
    else

      #!!!!!!!!DANGER! Destroy all teams, and goals before importing and re-creating
      #Groups, we keep and throw out any rows that don't match one of them.
      Goal.destroy_all
      Team.destroy_all


      CSV.foreach(file.path, headers: true) do |row|
        group_name = row['group'].to_s.titlecase
        team_name = row['team']

        next if group_name == 'n/a' || group_name.to_s.empty?

        #find the group
        group = groups[group_name] || Group.find_or_create_by(:name=>group_name)
        #hacky way to convert £30,000.23 to 30000,
        #should probably use monitize gem later but nervous about clashes with money-rails
        group.budget = row['group_budget'].scan(/[\d+\.]/).join.to_i
        group.headcount = row['group_headcount'].to_i
        group.save!

        groups[group_name] = group

        #lookup or create the team
        #save to our hash for faster lookups
        unless team_name.to_s.empty?
          team = teams[team_name] || Team.find_or_create_by(:name=>team_name.to_s)
          team.group = group
          team.save!
          teams[team.name] = team
        end


        #work backwords up the chain...
        #need to make this smarter so it doesn't rely on colum heading names
        [4,3,2].each do |level_number|
          goal_name = row["level_" + level_number.to_s]
          next if goal_name.to_s.empty?

          goal = goals[goal_name] || Goal.find_or_create_by(:name=>goal_name)
          goal.group = group

          #only apply a team and a deadline if we're a "leaf" (e.g. no child goal)
          if(row["level_" + (level_number+1).to_s].to_s.empty?)
            goal.team = team

            begin
              deadline = Date.parse(row['deadline'])
            rescue
              return "Import Failed! Invalid date for goal: #{goal_name}"
            end

            goal.deadline = deadline
          end

          #lookup the parent
          if(level_number > 2)
            parent_goal_name = row["level_" + (level_number-1).to_s]
            parent = goals[parent_goal_name] || Goal.find_or_create_by(:name=>parent_goal_name)
            goal.parent = parent
            goals[parent.name] = parent
          end

          goal.save!
          #add to hash
          goals[goal.name] = goal

        end #column loops
      end #end rows
    end #end cols not missing not blank
  end
end
