class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    return unless Question.last24h.any?
    User.find_each do |user|
      QuestionMailer.daily_digest(user).deliver_later
    end
  end
end
