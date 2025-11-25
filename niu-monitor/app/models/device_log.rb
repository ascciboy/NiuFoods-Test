class DeviceLog < ApplicationRecord
  belongs_to :device

  SEVERITIES = %w[info warning trouble critical].freeze

  validates :previous_status, :new_status, presence: true
  validates :severity, inclusion: { in: SEVERITIES }, allow_nil: true
end
