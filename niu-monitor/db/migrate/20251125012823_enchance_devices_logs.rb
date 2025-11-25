class EnchanceDevicesLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :device_logs, :severity, :string
    add_column :device_logs, :reason, :string
    add_column :device_logs, :impact, :string
    add_column :device_logs, :metrics_snapshot, :jsonb, default: {}

    add_index :device_logs, :severity
    add_index :device_logs, :reason
  end
end
