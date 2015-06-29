FactoryGirl.define do
  factory :answer do
    question nil
    body 'Read the following manual'
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
  end
end
