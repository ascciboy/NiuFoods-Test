class Device < ApplicationRecord
  belongs_to :restaurant
  belongs_to :device_type
  has_many :device_logs, dependent: :destroy

  STATUSES = %w[unknown operative warning trouble critical].freeze

  validates :name, :status, presence: true
  validates :status, inclusion: { in: STATUSES }

  before_update :register_status_change, if: :will_save_change_to_status?

  def report_status(new_status:, reported_at: Time.current)
    update(
      status: new_status,
      last_connection_at: reported_at
    )
  end

  private

  def register_status_change
    device_logs.create(
      previous_status: status_was,
      new_status: status,
      details: "API reported change",
      reported_at: last_connection_at,
      processed_at: Time.current
    )

    restaurant.update_overall_status!
  end
end
