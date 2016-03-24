class Team < ActiveRecord::Base
  default_scope{ order('name') }
  belongs_to :group
  has_many :roles
  has_many :goals, -> {order 'deadline'}
end
