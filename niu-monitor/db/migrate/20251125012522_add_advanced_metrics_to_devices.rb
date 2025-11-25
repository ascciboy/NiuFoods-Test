class AddAdvancedMetricsToDevices < ActiveRecord::Migration[8.1]
  def change
    add_column :devices, :battery_level,           :integer
    add_column :devices, :signal_strength,         :integer
    add_column :devices, :network_latency_ms,      :integer
    add_column :devices, :cpu_usage,               :integer
    add_column :devices, :memory_usage,            :integer
    add_column :devices, :temperature_celsius,     :float

    add_column :devices, :packet_loss_pct,         :float
    add_column :devices, :download_speed_mbps,     :float
    add_column :devices, :upload_speed_mbps,       :float
    add_column :devices, :connected_clients_count, :integer

    add_column :devices, :paper_status,            :string
    add_column :devices, :recording_status,        :string
    add_column :devices, :storage_available_gb,    :float
  end
end
