class Event < ActiveRecord::Base
  belongs_to :creator, class_name: "User", :foreign_key => 'creator_id'
  has_and_belongs_to_many :users, join_table: "events_users"
  belongs_to :city
  has_many :targets
  has_many :invitations

  validates :event_name, presence: true
  validates :start_date, presence: true
  validates :registration_deadline, presence: true
  validates :event_date, presence: true

  validate :validate_dates

  def validate_dates
    if event_date < registration_deadline
      errors.add(:event_date, "can't be less than the registration deadline")
    end
    if registration_deadline < start_date
      errors.add(:registration_deadline, "can't be less than the start date")
    end
  end

end
