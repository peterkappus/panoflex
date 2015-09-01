class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :title
      t.string :type
      t.decimal :monthly_cost
      t.decimal :apr
      t.decimal :may
      t.decimal :jun
      t.decimal :jul
      t.decimal :aug
      t.decimal :sep
      t.decimal :oct
      t.decimal :nov
      t.decimal :dec
      t.decimal :jan
      t.decimal :feb
      t.decimal :mar
      t.text :comments
      t.string :function
      t.string :team

      t.timestamps null: false
    end
  end
end
