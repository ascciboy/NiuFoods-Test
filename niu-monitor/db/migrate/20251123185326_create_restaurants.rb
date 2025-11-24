class CreateRestaurants < ActiveRecord::Migration[8.1]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :city, null: false

      t.string :status, null: false, default: "Unknown"
      t.datetime :last_report_at
      t.integer :issues_count, default: 0
      t.integer :critical_issues_count, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :restaurants, :status
    add_index :restaurants, :active
  end
end