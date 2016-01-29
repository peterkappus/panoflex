class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :amount
      t.text :reason
      t.integer :goal_id

      t.timestamps null: false
    end
  end
end
