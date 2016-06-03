class User < ActiveRecord::Base
  #sort by name
  default_scope { order('name') }

  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  has_many :goals, -> {order 'deadline'}

  paginates_per 15
end
