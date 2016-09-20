require_relative 'feature_helper'

feature 'Delete answer to a question', %q(
    In order to remove incorrect answer
    As an Authenticated user
    I want to be able to delete my answer to a question
  ) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user deletes his answer to question', js: true do
    sign_in(user)
    visit question_path(question)
    within ".answer-#{answer.id}" do
      click_on 'Delete'
    end

    expect(page).to have_content 'Your answer has been deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'Non-authenticated user tries to delete an answer' do
    visit question_path(question)
    within ".answer-#{answer.id}" do
      expect(page).to_not have_content 'Delete'
    end
  end
end
