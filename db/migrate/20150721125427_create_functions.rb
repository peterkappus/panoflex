class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|
      t.string :name
      t.string :short_name
      t.text :mission

      t.timestamps null: false
    end
  end
end
