FactoryGirl.define do
  factory :vote do
    votable_id ""
    votable_type ""
    vote 1
  end

  factory :question_vote, class: "Vote" do 
    vote 1
    votable_type "Question"
    votable_id nil
    user_id nil
  end

  factory :answer_vote, class: "Vote" do
    vote 1
    votable_type "Answer"
    votable_id nil
    user_id nil
  end
end
