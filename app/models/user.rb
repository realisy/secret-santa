class User < ActiveRecord::Base
  has_secure_password

  belongs_to :city
  has_many :gifts
  has_many :owned_events, class_name: 'Event', foreign_key: 'user_id'
  has_many :targets
  has_many :recipients, through: :recipients_target, source: :recipient
  has_many :recipients_target, foreign_key: :santa_id, class_name: "Target"


  has_many :santas, through: :santas_target, source: :santa
  has_many :santas_target, foreign_key: :recipient_id, class_name: "Target"
 
  has_many :invitations
  has_and_belongs_to_many :events
  has_many :organized_events, class_name: "Event"


  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :city, presence: true


end
