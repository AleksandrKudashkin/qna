require_relative 'feature_helper'

feature 'Subscribe to question', %q(
  In order to have recent answer to an interesting question
  As an authenticated user
  I want to be able to subscribe to question
  And receive its new answers
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }

  describe 'non-authenticated user' do
    scenario 'user does not see a link to subscribe' do
      visit question_path(question)
      expect(page).to_not have_link 'Subscribe'
    end
  end

  describe 'authenticated user' do
    background { sign_in(other_user) }
    scenario 'user sees a link to subscribe' do
      visit question_path(question)
      expect(page).to have_link 'Subscribe'
    end

    scenario 'after subscribing user sees subscribed message', js: true do
      visit question_path(question)
      click_on 'Subscribe'
      expect(page).to have_content 'subscribed!'
      expect(page).to_not have_link 'Subscribe'
    end
  end

  describe 'author of the question' do
    scenario 'he sees subscribed message', js: true do
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content 'subscribed!'
    end
  end
end
