class Goal < ActiveRecord::Base
  enum status: [:not_started, :on_track, :off_track, :significant_delay, :delivered ]

  validates_presence_of :name, :start_date, :deadline
  #validates :team, inclusion: { in: group.teams}
  validates_with TeamGroupValidator
  #validate :end_date_is_after_start_date

  belongs_to :team
  belongs_to :group
  belongs_to :owner, :class_name=>"User", :foreign_key=>"user_id"
  has_many :children, :class_name=>'Goal', :foreign_key=>'parent_id', dependent: :nullify
  has_many :scores, -> { order('created_at DESC') },  dependent: :destroy
  belongs_to :parent, :class_name=>'Goal', :foreign_key=>'parent_id'
  default_scope { order('created_at') }

  #default end dates to the end of the month and start dates to the beginning fo the month
  before_save {|record| record.deadline = record.deadline.end_of_month if(record.deadline)}
  before_save {|record| record.start_date = record.start_date.beginning_of_month if(record.start_date)}
  #after_save{|goal| goal.update_calculations}

  # don't use, dependent: :destroy ... better to orphan goals when the parent is deleted so that they can be re-assigned at some point and we don't lose history. TODO: create a way to archive goals instead of destroying them if thye're no longer "active". Ditto for scores...

  MAX_LEVELS = 5
  #SIMPLE_CSV_HEADERS = %w(id parent_id name owner_name owner_email status narrative updated_at status_updated_by_name status_updated_by_email)

  CSV_HEADERS = %w(group group_budget group_headcount team level_1 level_1_status level_1_narrative level_1_updated_by level_1_updated_at level_2 level_2_status level_2_narrative level_2_updated_by level_2_updated_at level_3 level_3_status level_3_narrative level_3_updated_by level_3_updated_at level_4 level_4_status level_4_narrative level_4_updated_by level_4_updated_at level_5 level_3_status level_3_narrative level_3_updated_by level_3_updated_at start_date deadline score_datetime score_amount score_reason)

  scope :gds_goals, -> {where("parent_id is null")}

  #convenience wrappers
  #TODO: rename deadline to end date in schema and everywhere else.
  def end_date
    deadline
  end

  #alias
  def sub_goals
    children
  end


  #next and previous goals
  def previous_goal
      if(parent.present?)
        current_index = parent.children.to_a.index(self)
        if(current_index > 0)
          parent.children.to_a[current_index-1]
        end
      else
        current_index = group.top_level_goals.to_a.index(self)
        if(current_index > 0)
          group.top_level_goals.to_a[current_index-1]
        end
      end
  end

  def next_goal
      if(parent.present?)
        current_index = parent.children.to_a.index(self)
        parent.children.to_a[current_index+1]
      else
        group.top_level_goals.to_a[group.top_level_goals.to_a.index(self)+1]
      end
  end

  def self.search(words)
    if(words)
      where('lower(name) LIKE ?',"%#{words.downcase}%") +       User.where("lower(name) LIKE ? ","%#{words.downcase}%").collect{|u| u.goals}.flatten
    else
      all
    end
  end

  def display_date_range
    start_date.strftime("%h %Y") + " - " + deadline.strftime("%h %Y")
  end

  #depth-first recursion to find score
  #SLOOOOWWWW
  #TODO: replace with bottom up method to set all upstream scores when a goal receives a progress update (score).
  def calculated_amount
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
      score_amount = children.map{|c| c.calculated_amount}.inject(:+).to_f / children.count
    end
    #save!
    #score_amount #dumb, but I need to return this value. Not the "true" from the save above
  end


  def update_calculations
    #update the dates of the ancestors
    calculate_dates

    #not doing this anymore...
    #calculate_scores
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

    #logger.info "hello"
    #update columns without triggering callbacks. CAREFUL!
    update_column(:score_amount, score_amount)
    update_column(:scored_at, scored_at)

    #update all the upstream goals until we reach the top level
    parent.calculate_scores unless parent.nil?
  end

  #SIMPLE_CSV_HEADERS = %w(id parent_id group_name team_name name owner_name owner_email status narrative updated_at status_updated_by_name status_updated_by_email)

  def group_name
    group.nil? ? nil : group.name
  end

  def display_amount
    #TODO: use pre-calculated "score_amount"...don't do it in realtime"
    (score_amount.to_f.round || 0).to_s + "%"
  end

  def current_display_date
    #TODO make this smarter, needs to take the most recent score date from the children in a similar way to how we get the current amount above..
    score ? score.display_date : ""
  end

  #latest score
  def score
    scores.first
  end

  #narrative from the latest status update
  def narrative
    score.nil? ? nil : score.reason
  end

  #narrative from the latest status update
  def status_updated_at
    score.nil? ? nil : score.updated_at
  end

  def status_updated_by_name
    score.nil? ? nil : score.user.name
  end

  def status_updated_by_email
    score.nil? ? nil : score.user.email
  end

  def status
    score.nil? ? Score.new(status: :not_started).status : score.status
  end

  def owner_name
      owner.nil? ? nil : owner.name
  end
  def owner_email
      owner.nil? ? nil : owner.email
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
      #if all the child goals are of the same team, return that.
      #otherwise, traverse the kids, if they all have the same team (and it isn't nil) then return that. Otherwise, return nil.
      unique_child_teams = children.map{|c| c.get_team}.uniq
      if(unique_child_teams.count == 1 && !unique_child_teams.first.nil?)
        unique_child_teams.first
      end
    end
  end

  def find_earliest_start_date
    if(children.empty?)
      if(start_date.nil?)
        #if we have no children, copy the earliest_start_date to our start date
        update_column(:start_date, earliest_start_date)
      end
      start_date
    else
      children.map{|c| c.find_earliest_start_date}.min
    end
  end

  def find_latest_end_date
    if(children.empty?)
      if(start_date.nil?)
        #if we have no children, copy from latest_end_date
        update_column(:deadline, latest_end_date)
      end
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

  def self.to_csv
    require 'csv'
    CSV.generate() do |csv|

      simple_csv_headers = %w(id parent_id name start_date deadline owner_name owner_email status narrative updated_at status_updated_by_name status_updated_by_email)
      csv << simple_csv_headers

      all.each do |g|
        #csv << g.attributes.values_at(*simple_csv_headers)
        csv << simple_csv_headers.map{|h| g.send(h.to_sym)}
      end
    end
  end

  #export tree to CSVreload
  def self.tree_export
    require 'csv'

    CSV.generate() do |csv|
      csv << CSV_HEADERS

      row_data = {}

      #one leaf per row
      rows = []

      gds_goals.each do |top_level_goal|
        top_level_goal.get_level(rows,row_data,1)
      end

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
        (1..MAX_LEVELS).to_a.reverse_each do |level_number|
          goal_name = row["level_" + level_number.to_s]
          next if goal_name.to_s.empty?

          begin
            deadline = Date.parse(row['deadline'])
          rescue
            return "Import Failed! Invalid end date for goal: #{goal_name}"
          end

          begin
            start_date = Date.parse(row['start_date'])
          rescue
            return "Import Failed! Invalid Start Date for goal: #{goal_name}"
          end

          goal = goals[goal_name] || Goal.find_or_create_by!(:name=>goal_name, start_date: start_date, deadline: deadline)

          goal.group = group
          goal.team = team

          #lookup the parent
          if(level_number > 1)
            parent_goal_name = row["level_" + (level_number-1).to_s]
            parent = goals[parent_goal_name] || Goal.find_or_create_by(:name=>parent_goal_name, start_date: start_date, deadline: deadline)
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

  private

  def end_date_is_after_start_date
    return if deadline.blank? || start_date.blank?

    earliest_child_start_date = children.map{|c| c.deadline}.min if children.count > 0
    latest_child_deadline = children.map{|c| c.deadline}.max if children.count > 0

    #ensure deadline is after latest child deadline
    if children.count > 0 && deadline < latest_child_deadline
      errors.add(:deadline, "must be after (or equal to) the latest sub-goal deadline: #{latest_child_deadline}")
    end

    #ensure start_date is before earliest child start date
    if children.count > 0 && start_date > earliest_child_start_date
      errors.add(:start_date, "must be earlier (or equal to) the earliest sub-goal start date: #{earliest_child_start_date}")
    end

    #now do the inverse...

    #ensure deadline is <= parent deadline
    if parent.present? && deadline > parent.deadline
      errors.add(:due_date, "must be earlier (or equal to) parent deadline: #{parent.deadline}")
    end

    #ensure start_date is >= parent start_date
    if parent.present? && start_date < parent.start_date
      errors.add(:start_date, "must be after (or equal to) parent start date: #{parent.start_date}")
    end

    #finally...

    #make sure start_date is after parent start-date
    if parent.present? && deadline < parent.start_date
      errors.add(:start_date, "must be after (or equal to) parent start date: #{parent.start_date}")
    end

    #deadline after start date
    if deadline < start_date
      errors.add(:due_date, "cannot be before the start date.")
    end
  end
end
