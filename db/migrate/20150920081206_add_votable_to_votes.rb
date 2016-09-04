class AddVotableToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :votable_type, :string
    add_column :votes, :votable_id, :integer
    add_index :votes, [:votable_id, :votable_type]
  end
end
