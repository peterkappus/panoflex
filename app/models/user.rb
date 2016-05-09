class User < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :email
  paginates_per 50
end
