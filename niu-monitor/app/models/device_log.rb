class DeviceLog < ApplicationRecord
  belongs_to :device

  validates :previous_status, :new_status, presence: true
end
