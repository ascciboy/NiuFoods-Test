class Device < ApplicationRecord
  belongs_to :restaurant
  belongs_to :device_type
  has_many :device_logs, dependent: :destroy

  STATUSES = %w[unknown operative warning trouble critical].freeze

  validates :name, :status, presence: true
  validates :status, inclusion: { in: STATUSES }

  before_update :enqueue_status_log, if: :will_save_change_to_status?
  after_update :enqueue_metrics_log, if: :metrics_changed?

  def report_status(new_status:)
    previous = status
    update(status: new_status, last_connection_at: Time.current)

    DeviceLogWorker.perform_async(id, previous, new_status, "Status updated") if previous != new_status
  end

  private

  def enqueue_status_log
    return if saved_change_to_last_connection_at? && !saved_change_to_status?

    DeviceLogWorker.perform_async(
      id,
      status_was,
      status,
      "Status updated by system",
      nil
    )
  end


  def enqueue_metrics_log
    snapshot = metrics_snapshot
    return if snapshot.empty?

    cleaned = clean_snapshot(snapshot)
    reason  = detect_metric_reason(cleaned)

    DeviceLogWorker.perform_async(
      id,
      status,
      status,
      reason,
      cleaned
    )
  end
 
  def metrics_snapshot
    saved_changes.slice(
      "battery_level", "signal_strength", "network_latency_ms",
      "cpu_usage", "memory_usage", "temperature_celsius",
      "packet_loss_pct", "download_speed_mbps", "upload_speed_mbps",
      "connected_clients_count", "paper_status", "recording_status",
      "storage_available_gb"
    )
  end

  def clean_snapshot(snapshot)
    snapshot.transform_values { |arr| arr.last }
            .reject { |_k, v| v.nil? }
            .to_h
  end

  def detect_metric_reason(clean_snapshot)
    return "high_temperature" if clean_snapshot["temperature_celsius"].to_f > 65
    return "low_battery"      if clean_snapshot["battery_level"].to_i < 15
    return "high_packet_loss" if clean_snapshot["packet_loss_pct"].to_f > 20
    return "storage_low"      if clean_snapshot["storage_available_gb"].to_f < 1

    "metrics_anomaly"
  end

  def metrics_changed?
    saved_changes.keys.intersect?(
      %w[
        battery_level signal_strength network_latency_ms
        cpu_usage memory_usage temperature_celsius
        packet_loss_pct download_speed_mbps upload_speed_mbps
        connected_clients_count paper_status recording_status
        storage_available_gb
      ]
    )
  end
end
