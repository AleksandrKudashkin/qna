class AddUserToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :user_id, :integer
    add_index :answers, :user_id
    add_foreign_key :answers, :users
  end
end
