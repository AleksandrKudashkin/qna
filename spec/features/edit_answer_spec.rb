require_relative 'feature_helper'

feature 'Answer editing', %q(
  In order to fix mistakes
  As an author of Answer
  I want to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:f2_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:f2_answer) { create(:answer, question: question, user: f2_user) }

  scenario 'Non-authenticated user tries to edit an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to edit his answer' do
      within '.answers-body' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'sees edit links only to his answers' do
      within ".answer-#{answer.id}" do
        expect(page).to have_link 'Edit'
      end
      within ".answer-#{f2_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'tries to edit his answer', js: true do
      within '.answers-body' do
        click_on 'Edit'
        fill_in 'Your answer:', with: 'Read the following manual twice (edited)!'
        click_on 'Save'

        expect(page).to have_content 'Read the following manual twice (edited)!'
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
end
