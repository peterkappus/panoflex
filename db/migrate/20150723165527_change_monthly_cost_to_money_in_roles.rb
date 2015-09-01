class ChangeMonthlyCostToMoneyInRoles < ActiveRecord::Migration
  def change
    change_table :roles do |t|
      #use "add_monetize" because we're using pg database
      t.monetize :monthly_cost
    end
  end
end
