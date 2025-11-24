class CreateDeviceTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :device_types do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :requires_network, null: false, default: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :device_types, :name, unique: true
  end
end