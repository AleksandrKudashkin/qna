FactoryGirl.define do
  factory :answer do
    question nil
    answer_body 'Read the following manual'
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    answer_body nil
  end
end
