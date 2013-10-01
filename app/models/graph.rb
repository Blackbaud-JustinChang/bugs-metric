class Graph < ActiveRecord::Base
  attr_accessible :name, :search
  validates :search, presence: true
  validates :name, presence: true
end
