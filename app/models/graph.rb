class Graph < ActiveRecord::Base
  attr_accessible :name, :search, :in_summary
  validates :search, presence: true
  validates :name, presence: true
end
