class City < ActiveRecord::Base
  has_many :users
  has_many :events

  validates :city_name, uniqueness: true, presence: true
  validates :province, presence: true
  validates :country, presence: true
end
