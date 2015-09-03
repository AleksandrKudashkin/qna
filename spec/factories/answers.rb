FactoryGirl.define do
  factory :answer do
    question nil
    sequence(:body) { |n| "Read the following manual#{n}" } 
    user nil
    bestflag false
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user nil
    bestflag nil
  end
end
