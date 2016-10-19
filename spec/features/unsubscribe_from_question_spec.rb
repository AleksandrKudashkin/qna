require_relative 'feature_helper'

feature 'Unsubscribe to question', %q(
  In order to stop watching unimportant question
  As an authenticated user
  I want to be able to unsubscribe from the question
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given!(:subscription) { create(:subscription, user: other_user, question: question) }

  describe 'non-authenticated user' do
    scenario 'user does not see a link to subscribe' do
      visit question_path(question)
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  describe 'authenticated user' do
    background { sign_in(other_user) }
    scenario 'user sees a link to unsubscribe' do
      visit question_path(question)
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'after unsubscribing user sees subscribe button', js: true do
      visit question_path(question)
      click_on 'Unsubscribe'
      expect(page).to_not have_content 'subscribed!'
      expect(page).to have_link 'Subscribe'
    end
  end
end
