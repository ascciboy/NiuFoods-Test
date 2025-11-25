class DeviceLogWorker
  include Sidekiq::Worker

  def perform(device_id, previous_status, new_status, reason, snapshot = {})
    device = Device.find(device_id)

    device.device_logs.create!(
      previous_status: previous_status,
      new_status: new_status,
      reason: reason,
      severity: severity_for(reason, new_status),
      impact: business_impact(device, new_status),
      details: details_for(reason),
      metrics_snapshot: snapshot.presence || current_metrics(device),
      reported_at: Time.current,
      processed_at: Time.current
    )

    device.restaurant.update_overall_status!
  end

  private

  def severity_for(reason, status)
    return "critical" if status == "critical"
    return "major" if %w[high_temperature high_packet_loss offline].include?(reason)
    return "minor" if %w[low_battery storage_low metrics_anomaly].include?(reason)
    "info"
  end

  def business_impact(device, status)
    return "Payments unavailable" if device.device_type.name == "POS Terminal" && status != "operative"
    return "Receipt printing unavailable" if device.device_type.name == "Fiscal Printer" && status != "operative"
    return "Orders delayed" if device.device_type.name == "Kitchen Screen (KDS)" && status != "operative"
    return "Security compromised" if device.device_type.name == "Security Camera" && status != "operative"
    return "Network disruption" if device.device_type.name == "WiFi Router" && status != "operative"
    "Partial functionality impact"
  end

  def details_for(reason)
    {
      "high_temperature" => "Device overheating",
      "low_battery" => "Battery critically low",
      "high_packet_loss" => "Severe network loss detected",
      "storage_low" => "Device storage almost full",
      "metrics_anomaly" => "Metric deviation detected"
    }[reason] || "Status change detected"
  end

  def current_metrics(device)
    {
      battery: device.battery_level,
      signal: device.signal_strength,
      cpu: device.cpu_usage,
      memory: device.memory_usage,
      temp: device.temperature_celsius,
      packet_loss: device.packet_loss_pct,
      down: device.download_speed_mbps,
      up: device.upload_speed_mbps,
      storage_free: device.storage_available_gb
    }.compact
  end
end
