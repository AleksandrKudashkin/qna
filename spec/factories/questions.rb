FactoryGirl.define do

  factory :question do
    sequence(:title) { |n| "MyTitle#{n}" }
    sequence(:body)  { |n| "MyQuestionText#{n}" }
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
