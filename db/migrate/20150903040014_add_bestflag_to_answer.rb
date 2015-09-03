class AddBestflagToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :bestflag, :boolean
  end
end
