class User < ActiveRecord::Base
  has_secure_password

  belongs_to :city
  has_many :gifts
  has_many :owned_events, class_name: 'Event', foreign_key: 'user_id'
  has_many :recipients, through: :recipients_target, source: :recipient
  has_many :recipient_targets, foreign_key: :recipient_id, class_name: "Target"


  has_many :santas, through: :santas_target, source: :santa
  has_many :santa_targets, foreign_key: :santa_id, class_name: "Target"

  has_and_belongs_to_many :events

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true


end
