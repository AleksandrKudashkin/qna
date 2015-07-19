FactoryGirl.define do
  factory :answer do
    question nil
    sequence(:body) { |n| "Read the following manual#{n}" } 
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
  end
end
