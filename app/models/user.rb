class User < ActiveRecord::Base
  belongs_to :city
  has_and_belongs_to_many :gifts
  has_many :events
  has_and_belongs_to_many :events
end
