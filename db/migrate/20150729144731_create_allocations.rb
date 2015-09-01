class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.date :date
      t.decimal :amount, precision: 10, scale: 2
      t.integer :role_id

      t.timestamps null: false
    end
  end
end
