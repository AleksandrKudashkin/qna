require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do
  
  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
    sign_in(user)

    visit questions_path
    click_on 'Задать свой вопрос'
    fill_in 'Заголовок:', with: 'Тестовый вопрос'
    fill_in 'Опишите свой вопрос подробнее:', with: 'Text, Text. Text?'
    click_on 'Задать вопрос!'

    expect(page).to have_content 'Ваш вопрос успешно создан!'
  end

  scenario 'Non-authenticated user tries to create a question' do
    visit questions_path
    click_on 'Задать свой вопрос'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
