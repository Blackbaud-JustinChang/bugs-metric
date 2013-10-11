class AddUsernameToGraph < ActiveRecord::Migration
  def change
    add_column :graphs, :username, :string
  end
end
