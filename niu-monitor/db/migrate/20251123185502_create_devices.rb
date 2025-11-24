class CreateDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :devices do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.references :device_type, null: false, foreign_key: true

      t.string :name, null: false
      t.string :status, null: false, default: "unknown"
      t.boolean :critical, null: false, default: false

      t.datetime :last_connection_at
      t.string :ip_address
      t.string :location
      t.string :firmware_version
      t.boolean :is_network_reachable, default: false

      t.timestamps
    end

    add_index :devices, [:restaurant_id, :name], unique: true
    add_index :devices, :status
    add_index :devices, :critical
  end
end