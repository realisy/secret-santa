class Target < ActiveRecord::Base
  belongs_to :santa, class_name: "User", foreign_key: "santa_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :events

  validates :event, uniqueness: { scope: :santa, scope: :recipient }
end