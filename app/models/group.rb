class Group < ActiveRecord::Base
  has_many :roles
  has_many :teams
end
