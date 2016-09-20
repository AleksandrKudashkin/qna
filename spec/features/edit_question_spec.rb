require_relative 'feature_helper'

feature 'Question editing', %q{
  In order to edit my Question
  As an authenticated user and author of the Question
  I want to be able to edit question (title and body)
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Non-authenticated user tries to edit a question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    given(:user2) { create(:user) }
    given!(:question2) { create(:question, user: user2) }

    scenario 'sees link to edit his question' do
      visit question_path(question)

      within '.question' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'does not see edit form until press Edit', js: true do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_content 'Title:'
        expect(page).to_not have_content 'Description:'
      end
    end

    scenario 'does not see the link to edit not his question' do
      visit question_path(question2)
      within '.question' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'can edit his question', js: true do
      visit question_path(question)
      within '.question' do
        click_on 'Edit'

        fill_in 'Title:', with: 'Edited title'
        fill_in 'Description:', with: 'Edited body'
        click_on 'Save'

        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end
