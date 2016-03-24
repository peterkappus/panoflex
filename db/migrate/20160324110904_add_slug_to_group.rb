class AddSlugToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :slug, :string
  end
end
