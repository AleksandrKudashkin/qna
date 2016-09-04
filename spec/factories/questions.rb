FactoryGirl.define do

  factory :question do
    sequence(:title) { |n| "MyTitle#{n}" }
    sequence(:body)  { |n| "MyQuestionText#{n}" }
    user nil
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user nil
  end
end
