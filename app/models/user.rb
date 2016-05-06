class User < ActiveRecord::Base
  paginates_per 50
end
