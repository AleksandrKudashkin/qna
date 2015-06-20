FactoryGirl.define do
  factory :question do
    title 'MyTitle'
    question_body 'MyQuestionText'
  end

  factory :invalid_question, class: "Question" do
    title nil
    question_body nil
  end
end
