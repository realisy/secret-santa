class User < ActiveRecord::Base
  has_secure_password

  belongs_to :city
  has_many :gifts
  has_many :owned_events, class_name: 'Event', foreign_key: 'user_id'
  has_and_belongs_to_many :events

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true


end
