class Score < ActiveRecord::Base
  enum status: [:not_started, :on_track, :off_track, :significant_delay, :delivered ]

  belongs_to :goal
  belongs_to :user
  validates_presence_of :goal, :reason, :status, :user

  #validates :amount, numericality: { only_integer: true}
  #after_save -> {goal.calculate_scores}
  after_save -> {goal.status = status; goal.save!}

  #TODO: don't allow saving scores to a goal with children.

  #scope :latest, lambda { order("updated_at desc").first}

  #probably should add an actual date field that the user can adjust
  #for now, use updated_at
  def date
    updated_at
  end

  def user_name
    user.name
  end

  def goal_name
    goal.name
  end

  def email
    user.email
  end

  def display_amount
    amount.to_i.to_s + "%"
  end

  def display_date
    date.strftime("%d %h %Y")
  end

  def self.to_csv
    require 'csv'
    CSV.generate() do |csv|

      simple_csv_headers = %w(id goal_id goal_name status reason updated_at user_name email)

      #add headers
      csv << simple_csv_headers

      #loop through all scores
      all.each do |score|
        #add a row for each, converting each header to a symbol and calling that method on the score
        csv << simple_csv_headers.map{|h| score.send(h.to_sym)}
      end
    end
  end

end
