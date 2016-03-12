class Role < ActiveRecord::Base

  order(:staff_number)
  #scope :by_function, ->(id) { where(:function_name => id)}
  scope :vacant, -> {where("lower(name) like '%vac%' or lower(staff_number) = 'vacant'")}
  scope :na_people, -> {where("lower(staff_number) like '%#n/a%'")}
  scope :filled, -> {where("lower(name) NOT like '%vacan%' and lower(staff_number) NOT like '%vacan%'")}

  #Vacant roles with start & end dates in the past
  #scope :vacant_past, -> {where("lower(name) NOT like '%vacan%'")}

  scope :empty, -> {where("(apr + may + jun + jul + aug + sep + oct + nov + dec + jan + feb + mar) = 0")}
  scope :vacant_empty, -> {where("lower(name) like '%vacan%' and (apr + may + jun + jul + aug + sep + oct + nov + dec + jan + feb + mar) = 0")}
  scope :vacant_by_date, ->(start_date,end_date) { vacant.where(start_date: start_date..end_date)}

  #case insensitive "where" method
  #http://billpatrianakos.me/blog/2013/10/19/case-insensitive-finder-methods-in-rails/
  scope :ci_where, lambda { |attribute, value| where("lower(#{attribute}) = ?", value.downcase) }
  scope :ci_like, lambda { |attribute, value| where("lower(#{attribute}) like ?", "%#{value.downcase}%") }

  #belongs_to :function
  belongs_to :team
  belongs_to :group
  has_many :allocations

  monetize :monthly_cost_cents, :as=>:monthly_cost
  monetize :total_cost_cents, :as=>:total_cost

  def vacant?
    self.staff_number.match(/vac/i)
  end

  def self.MONTH_NAMES
     %w(apr may jun jul aug sep oct nov dec jan feb mar)
  end

  #make this smarter!
  #return a hash of months with allocations
  def months
    months = {}
    Role.MONTH_NAMES.map{|m| months[m]=send(m).to_f}
    months
  end

  def self.update_all_total_costs
    Role.all.each do |r|
      r.update_total_cost
    end
  end

  def self.anonymise_staff_numbers
    Role.all.each do |r|
      r.staff_number = r.staff_number.sub(/.+?-\s+/,'')
      r.save!
    end
  end

  def update_total_cost
    self.total_cost = months.values.reduce(:+) * monthly_cost
    self.save!
  end

  def self.import(file)
    require 'csv' #probably should put this at the top, but I don't *always* want to include it... Some smarter way to bundle this up?

    required_cols = %w(group team title role_type staff_number monthly_cost sub_team) + Role.MONTH_NAMES

    #subtract supplied columns from required columns to see if any are missing
    missing_cols = required_cols - CSV.read(file.path,headers: true).headers

    if(!missing_cols.empty?)
      return "Missing columns: #{missing_cols.join(", ")}"
    else

      #WATCH OUT! :) Import replaces everything!
      Role.destroy_all

      CSV.foreach(file.path, headers: true) do |row|
        next if row['group'] == 'n/a'

        #new role to hold our values
        r = Role.new()

        #load up our object with data from each required column
        required_cols.each do |col_name|
          value = row[col_name]

          #cast monthly utilisation as floats (and convert nils to 0.0)
          if(Role.MONTH_NAMES.include? col_name)
            value = value.to_f
          end

          # skip group_name & team since we'll actually use the name to reference (or create) a group object.
          # should do the same with funciton_name and get rid of function_name in Role model
          if(col_name != "group" && col_name != "team")
            r.send("#{col_name}=",value)
          end

        end

        #strip pound signs and commas from monthly costs
        r.monthly_cost = Monetize.parse(row['monthly_cost'])

        #find or create by short name...
        r.team = Team.where(name: row['team']).first_or_create

        #eventually, we shouldn't associate roles directly to groups, just to teams
        r.group = Group.where(name: row['group']).first_or_create

        #assign the team to the group (team's group will always be the last one... this is why we need to remove the direct role -> group association)
        r.group.teams << r.team
        r.staff_number = r.staff_number.sub(/.+?-\s+/,'')
         #anonymise by removing name portion

        #start/end dates
        #r.calculate_dates

        #ineficient as this saves the record again...
        #r.total_cost = 3000 #r.update_total_cost
        #r.total_cost_pennies = Role.MONTH_NAMES.map{|month| send(month).to_f}.reduce(:+) * monthly_cost
        r.update_total_cost
        r.save!
        #end
      end
    end

    #destroy any groups (and their teams) without roles
    Group.all.map{|g| g.destroy if(g.roles.count <= 0)}
  end



=begin obsolete functions for finding start & end dates

  def set_date
    self.start_date = Date.parse("12 May 2014") #Time.today
    self.save!
  end

def calculate_dates
    start_date = start_of_year = Date.parse("1 apr 2015")
    end_date = start_date+11.months

    #find (and return) the first non-zero date
    while(send(start_date.strftime('%h').downcase) <= 0 && start_date <= start_of_year+1.year) do
      start_date += 1.month
      #puts start_date.strftime('%h').downcase
    end

    #find (and return) the first non-zero date
    while(send(end_date.strftime('%h').downcase) == 0 && end_date >= start_of_year) do
      end_date -= 1.month
      #puts end_date.strftime('%h').downcase
    end

    self.start_date = start_date
    self.end_date  = end_date.end_of_month # we don't know the actual end date, so assume end of month

    #save this record
    save!
end

def self.calculate_dates
  Role.all.each do |r|
    r.calculate_dates
  end
end
=end

    #TODO
    # migrate allocations from Roles table into new Allocations table
    def self.create_allocations
      Role.all.each do |r|
        start_date = Date.parse("1 apr 2015")
        r.months.keys.each do |month_name|
          a = Allocation.new
          #a.date = Date.parse("1 Apr 2015")
          #step through months Apr-Mar by adding months to the start month
          #get the value from the Roles table and assign to the correct allocation month
        end
      end
    end


=begin
composed_of :monthly_cost,
            :class_name => 'Money', :mapping => %w(monthly_cost cents),
            :converter => Proc.new {|value| value.respond_to?(:to_money) ? value.to_money : Money.empty }
=end
end
