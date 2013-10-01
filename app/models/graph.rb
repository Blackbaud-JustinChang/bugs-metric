class Graph < ActiveRecord::Base
  attr_accessible :end_date, :name, :product, :search, :start_date
  validates :end_date, presence: true
  validates :name, presence: true
  validates :product, presence: true
  validates :search, presence: true
  validates :start_date, presence: true
end
