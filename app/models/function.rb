class Function < ActiveRecord::Base
  has_many :roles
  #all vacancies at this moment
  scope :vacancies, ->() { Role.where("name ilike '%vaca%'")}
  #scope :roles_by_month, -> (month_name = Time.now.month.strftime("%b")) {Role.where("#{month_name} > 0")}

  def roles_by_month(month_name = Time.now.month.strftime("%b"))
    return unless(%w(apr may jun jul aug sep oct nov dec jan feb mar).include? month_name.downcase)
    roles.where("#{month_name} > 0")
  end

  def avg_cost_per_head
    (roles.count != 0) ? roles.map{|r| r.monthly_cost}.reduce(:+).to_f / roles.count : 0
  end

  def avg_headcount

  end

  def vacancies_by_month(month_name = Time.now.month.strftime("%b"))
    #horrid hack because utilisation is stored in columns named after the month.
    #need to break these out into a separate table with real dates for each monthly allocation
    #roles.where(roles.where("name ilike '%vaca%' and #{Date.parse("#{Time.now.year}-#{month_number}-1").strftime("%b").downcase.to_s} > 0"))

    #for now, just do it by month name.
    roles.where("name ilike '%vaca%' and #{month_name.downcase} > 0")
  end
end
