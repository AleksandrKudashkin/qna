require_relative 'feature_helper'

feature 'Delete answer to a question', %q{
    In order to remove incorrect question
    As an Authenticated user
    I want to be able to delete my question with all the answers
  } do

    given(:f_user) { create(:user) }
    given(:f2_user) { create(:user) }
    given!(:question) { create(:question, user: f_user) }
    given!(:answer) { create(:answer, question: question, user: f2_user) }

    scenario 'Authenticated user deletes his queston' do
      sign_in(f_user)

      visit question_path(question)

      click_on 'Удалить вопрос'
      
      expect(current_path).to eq questions_path
      expect(page).to have_content 'Ваш вопрос удалён!'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario 'Non-authenticated user tries to delete a question' do
      visit question_path(question)

      expect(page).to_not have_content 'Удалить вопрос'
    end
end