class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name
      t.references :team, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
