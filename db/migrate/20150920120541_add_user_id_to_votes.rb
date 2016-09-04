class AddUserIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :user_id, :integer
    add_index :votes, :user_id
    add_foreign_key :votes, :users
  end
end
