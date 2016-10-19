class NewAnswerJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    @subscribers = answer.question.subscribers
    @subscribers.find_each do |user|
      QuestionMailer.new_answer(user, answer).deliver_now
    end
  end
end
