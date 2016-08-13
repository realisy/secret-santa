class Gift < ActiveRecord::Base
  belongs_to :user

  validates :gift_name, presence: true

end
