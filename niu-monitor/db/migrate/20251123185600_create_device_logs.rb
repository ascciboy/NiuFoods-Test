class CreateDeviceLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :device_logs do |t|
      t.references :device, null: false, foreign_key: true

      t.string :previous_status, null: false
      t.string :new_status, null: false
      t.text :details

      t.datetime :reported_at
      t.datetime :processed_at

      t.timestamps
    end

    add_index :device_logs, :new_status
    add_index :device_logs, :reported_at
  end
end