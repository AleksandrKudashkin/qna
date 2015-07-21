class AddUserToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :user_id, :integer
    add_index :questions, :user_id
    add_foreign_key :questions, :users
  end
end
