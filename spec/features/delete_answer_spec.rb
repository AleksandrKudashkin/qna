require_relative 'feature_helper'

feature 'Delete answer to a question', %q{
    In order to remove incorrect answer
    As an Authenticated user
    I want to be able to delete my answer to a question
  } do
    
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario 'Authenticated user deletes his answer to question' do
      sign_in(user)

      visit question_path(question)

      click_on 'Удалить ответ'
      
      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Ваш ответ удалён!'
      expect(page).to_not have_content answer.body
    end

    scenario 'Non-authenticated user tries to delete an answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Удалить ответ'
    end
end