class Goal < ActiveRecord::Base
  validates_presence_of :name#, :start_date, :deadline
  #validates :team, inclusion: { in: group.teams}
  validates_with TeamGroupValidator

  belongs_to :team
  belongs_to :group
  #belongs_to :user #call them an "owner" not a 'user' for clarity
  belongs_to :owner, :class_name=>"User", :foreign_key=>"user_id"
  belongs_to :sdp_parent, :class_name=>'Goal', :foreign_key=>'sdp_parent_id'
  has_many :children, -> { order('earliest_start_date')}, :class_name=>'Goal', :foreign_key=>'parent_id', dependent: :nullify
  has_many :sdp_children, -> { order('earliest_start_date')}, :class_name=>'Goal', :foreign_key=>'sdp_parent_id'
  has_many :scores, -> { order('created_at DESC') },  dependent: :destroy
  belongs_to :parent, :class_name=>'Goal', :foreign_key=>'parent_id'

  #default end dates to the end of the month and start dates to the beginning fo the month
  before_save {|record| record.deadline = record.deadline.end_of_month if(record.deadline)}
  before_save {|record| record.start_date = record.start_date.beginning_of_month if(record.start_date)}

  after_save{|goal| goal.update_calculations}

  # don't use, dependent: :destroy ... better to orphan goals when the parent is deleted so that they can be re-assigned at some point and we don't lose history. TODO: create a way to archive goals instead of destroying them if thye're no longer "active". Ditto for scores...

  MAX_LEVELS = 5
  CSV_HEADERS = %w(group group_budget group_headcount team level_1 level_2 level_3 level_4 level_5 start_date deadline score_datetime score_amount score_reason)

  # TODO: validation...
  # group goals must have a parent GDS goal
  # GDS goals must NOT have any parent goals
  # GDS goals must NOT belong to a group or a team
  # team goals must have a parent goal which belongs to a group
  scope :gds_goals, -> {where("parent_id is null")}

  #is this goal an SDP goal?
  def is_sdp?
    sdp_id?
  end

  #convenience wrapper for end_date
  #TODO: rename deadline to end date in schema and everywhere else.
  def end_date
    deadline
  end

  #def display_deadline
  #  if(deadline)
  #    deadline.strftime("%d %h %Y")
  #  end
  #end

  def display_date_range
    #ensure we have dates
    if(earliest_start_date.nil? || latest_end_date.nil?)
      calculate_dates
    end

    earliest_start_date.strftime("%d %h %Y") + " - " + latest_end_date.strftime("%d %h %Y")
  end

  def group_name
    group.nil? ? "" : group.name
  end

  #depth-first recursion to find score
  #SLOOOOWWWW
  #TODO: replace with bottom up method to set all upstream scores when a goal receives a progress update (score).
  def current_amount
    #use the real score if we have one, otherwise assume zero
    #could make this more sophistocated later (e.g. use #N/A)

    #if we don't have child goals, use the current manual score
    #if there isn't a manually entered score, use zero
    #if we DO have children, average up the child scores
    #this should recursively follow all children to the bottom...
    #could be VERY slow with lots of kids... might want to make this an offline process and save the score inside the Goal model... TODO
    if(children.empty?)
      #return the score if there is one.
      score_amount = score ? score.amount : 0
    else
      score_amount = children.map{|c| c.current_amount}.inject(:+).to_f / children.count
    end
    #save!
    score_amount #dumb, but I need to return this value. Not the "true" from the save above
  end

  def display_amount
    #TODO: use pre-calculated "score_amount"...don't do it in realtime"
    (score_amount.to_f.round || 0).to_s + "%"
  end

  def current_display_date
    #TODO make this smarter, needs to take the most recent score date from the children in a similar way to how we get the current amount above..
    score ? score.display_date : ""
  end

  def update_calculations
    #console.lognote
    #update the dates of the ancestors
    calculate_dates
    calculate_scores
  end

  def calculate_scores
    #update downstream
    if children.count > 0
      score_amount = (children.map{|c| c.score_amount.to_i}.inject(:+).to_f / children.count).round
    else
      if(score.nil?)
        score_amount = 0
      else
        score_amount = score.amount
        scored_at = score.updated_at
      end
    end

    logger.info "hello"
    #update columns without triggering callbacks. CAREFUL!
    update_column(:score_amount, score_amount)
    update_column(:scored_at, scored_at)

    #update all the upstream goals until we reach the top level
    parent.calculate_scores unless parent.nil?
  end

  def score
    scores.first
  end

=begin
  def owner_name
      (owner) ? owner.name : "" # + " " + owner.class.name : ""
      #owner.name
  end

  def owner
    team || get_team || group
  end
=end

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
      #if all the child goals are of the same team, return that.
      #otherwise, traverse the kids, if they all have the same team (and it isn't nil) then return that. Otherwise, return nil.
      unique_child_teams = children.map{|c| c.get_team}.uniq
      if(unique_child_teams.count == 1 && !unique_child_teams.first.nil?)
        unique_child_teams.first
      end
    end
  end

  def find_earliest_start_date
    #TODO: add a column to cache this in the model
    if(children.empty?)
      start_date
    else
      children.map{|c| c.find_earliest_start_date}.min
    end
  end

  def find_latest_end_date
    if(children.empty?)
      deadline
    else
      children.map{|c| c.find_latest_end_date}.max
    end
  end

  def calculate_dates
      earliest_start_date = find_earliest_start_date
      latest_end_date = find_latest_end_date
      #sneaky... update without callbacks. CAREFUL!
      #otherwise, we get infinite recursion and stack overflow
      update_column(:earliest_start_date, find_earliest_start_date)
      update_column(:latest_end_date, find_latest_end_date)
      parent.calculate_dates unless parent.nil?
  end

  #recursively follow each branch to a leaf, then define the row using data for that leaf
  #add the leaf to the "rows" array and move on.
  def get_level(rows,row_data,depth)

    #set the name of this level
    row_data['level_' + depth.to_s] = self.name

    #are we at a leaf?
    if(self.children.count == 0)

      row_data['start_date'] = self.start_date.strftime("%d %h %Y")
      row_data['deadline'] = self.deadline.strftime("%d %h %Y")
      if(!self.group.nil?)
        row_data['group_budget'] = self.group.budget
        row_data['group_headcount'] = self.group.headcount
        row_data['group'] = self.group.name
      end

      if(!self.team.nil?)
        row_data['team'] = self.team.name
      end

      #slightly hacky, need to clear out any levels below this one if we're on a leaf.
      #otherwise, the lower-level data will still exist in this and subsequent rows
      ((depth+1)..5).each do |level|
        row_data['level_' + level.to_s] = ''
      end

      if(scores.count > 0)
        #loop through "updates" (aka "Scores" which is misleading)
        #TODO: rename these as "updates"
        scores.each do |score|
          row_data['score_datetime'] = score.created_at
          row_data['score_amount'] = score.amount
          row_data['score_reason'] = score.reason

          #add a row for each score/update
          #add this finished row
          rows<<row_data.values_at(*CSV_HEADERS)

          #now blank them out so they don't persist in the next iteration
          row_data['score_datetime'] = row_data['score_amount'] = row_data['score_reason'] = nil
        end
      else
          #just add a row for this "leaf" goal
          rows<<row_data.values_at(*CSV_HEADERS)
      end
    else
      #otherwise, keep traversing
      self.children.each do |child_goal|
        child_goal.get_level(rows,row_data,depth+1)
      end
    end

    #ultimately return the rows
    rows
  end

  def self.get_csv_rows
    rows = []
    row_data = {}
    gds_goals[3].get_level(rows,row_data,1)
  end

  #export to CSVreload
  def self.to_csv
    require 'csv'

    CSV.generate() do |csv|
      csv << CSV_HEADERS

      row_data = {}

      #one leaf per row
      rows = []

      gds_goals.each do |top_level_goal|
        top_level_goal.get_level(rows,row_data,1)
      end

      #gds_goals[3].get_level(rows,row_data,1)

      #binding.pry

      rows.each do |row|
        csv<<row
      end

    end

  end

  #Imports OKRs, Group and team names, headcount, budget, etc.
  #NOTE: Does NOT import scores (yet) Therefore, it should only be used when we have an empty database. Funciton returns an error if called when Goals.all.count > 0
  def self.import_okrs(file)
    require 'csv'

    raise "Cannot import OKRs because it would overwrite existing goals and scores. You must manually clear the database first." if Goal.all.count > 0

    #in-memory has saves us having to do a sql lookup for every row
    groups = {}
    teams = {}
    goals = {}

    required_cols = %w(group team level_1 level_2 level_3 level_4 start_date deadline)

    #subtract supplied columns from required columns to see if any are missing
    missing_cols = required_cols - CSV.read(file.path,headers: true).headers

    if(!missing_cols.empty?)
      return "Missing columns: #{missing_cols.join(", ")}"
    else

      #!!!!!!!!DANGER! Destroy all teams, and goals before importing and re-creating
      #Groups, we keep and throw out any rows that don't match one of them.
      #Goal.destroy_all
      #using the below method as it should restart the primary key index and break fewer links (e.g. Goal 5 should still be Goal 5 after a re-import)
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE goals RESTART IDENTITY")


      Team.destroy_all
      Score.destroy_all

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
        #need to make this smarter so it doesn't rely on column heading names
        (1..MAX_LEVELS).to_a.reverse.each do |level_number|
          goal_name = row["level_" + level_number.to_s]
          next if goal_name.to_s.empty?

          goal = goals[goal_name] || Goal.find_or_create_by(:name=>goal_name)
          goal.group = group

          #only apply a team and a deadline if we're a "leaf" (e.g. no child goal)
          if(row["level_" + (level_number+1).to_s].to_s.empty?)
            goal.team = team

            begin
              goal.deadline = Date.parse(row['deadline'])
            rescue
              return "Import Failed! Invalid end date for goal: #{goal_name}"
            end

            begin
              goal.start_date = Date.parse(row['start_date'])
            rescue
              return "Import Failed! Invalid Start Date for goal: #{goal_name}"
            end

          end

          #lookup the parent
          if(level_number > 1)
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
