class User < ActiveRecord::Base
  attr_accessible :username
  validates :username, presence: true
end
