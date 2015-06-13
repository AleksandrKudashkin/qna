class AddColumToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :answer_body, :text
  end
end
