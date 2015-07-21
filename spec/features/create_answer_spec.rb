require 'rails_helper'

feature 'Create answer to a question', %q{
    In order to help a man to solve his problem
    As an Authenticated user
    I want to be able to create an answer to a question
  } do
    
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'Authenticated user creates an answer to question' do
      sign_in(user)

      visit question_path(question)

      click_on 'Помочь человеку'
      fill_in 'Ваш ответ', with: 'Read the following manual!'
      click_on 'Дать ответ!'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Ваш ответ сохранён!'
      expect(page).to have_content 'Read the following manual'
    end

    scenario 'Non-authenticated user tries to create a question' do
      visit question_path(question)

      click_on 'Помочь человеку'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
end