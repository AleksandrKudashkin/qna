require 'rails_helper'

describe DailyDigestJob do
  let!(:users) { create_list(:user, 2) }
  let!(:questions) { create_list(:question, 2, created_at: 1.day.ago, user: users.first) }
  it 'sends daily digest' do
    users.each do |user|
      expect(QuestionMailer).to receive(:daily_digest).with(user).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
