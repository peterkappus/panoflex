class Team < ActiveRecord::Base
  #nice slugs! :)
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :finders]

  validates :name, uniqueness: true, presence: true
  default_scope{ order('name') }
  belongs_to :group
  has_many :roles
  has_many :goals, -> {order 'deadline'}

end
