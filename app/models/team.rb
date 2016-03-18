class Team < ActiveRecord::Base
  belongs_to :group
  has_many :roles
  has_many :goals
end
