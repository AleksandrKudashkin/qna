class AddCommentableToComment < ActiveRecord::Migration
  def change
    add_column :comments, :commentable_type, :string
    add_column :comments, :commentable_id, :integer
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
