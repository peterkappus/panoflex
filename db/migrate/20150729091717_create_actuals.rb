class CreateActuals < ActiveRecord::Migration
  def change
    create_table :actuals do |t|
      t.date :period
      t.string :cost_centre_description
      t.integer :account
      t.string :account_description
      t.string :account_type
      t.string :reference
      t.string :customer_or_supplier
      t.date :gl_date
      t.string :po_number
      t.text :description
      t.integer :debit
      t.integer :credit
      t.integer :total
      t.integer :cost_centre
      t.string :team

      t.timestamps null: false
    end
  end
end
