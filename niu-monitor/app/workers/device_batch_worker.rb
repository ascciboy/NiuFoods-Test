class DeviceBatchWorker
  include Sidekiq::Worker

  BATCH_SIZE = 100

  def perform
    reports = pop_reports(BATCH_SIZE)
    return if reports.empty?

    reports.each do |report|
      save_report(report)
    end
  end

  private

  def pop_reports(limit)
    items = []
    limit.times do
      json = $redis_metrics.rpop("device_reports")
      break unless json
      items << JSON.parse(json)
    end
    items
  end

  def save_report(data)
    device = Device.find_by(id: data["device_id"])
    return unless device

    metrics = data.slice(
      "status", "battery_level", "signal_strength", "network_latency_ms",
      "cpu_usage", "memory_usage", "temperature_celsius",
      "packet_loss_pct", "download_speed_mbps", "upload_speed_mbps",
      "connected_clients_count", "paper_status",
      "recording_status", "storage_available_gb"
    ).compact

    device.assign_attributes(metrics.merge(last_connection_at: Time.current))
    device.save!
  end
end
