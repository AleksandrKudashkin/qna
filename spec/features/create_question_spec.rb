require_relative 'feature_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do
  
  given!(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates a question' do
    sign_in(user)

    visit questions_path
    click_on 'Задать свой вопрос'
    fill_in 'Заголовок:', with: question.title
    fill_in 'Опишите свой вопрос подробнее:', with: question.body
    click_on 'Сохранить'

    expect(page).to have_content 'Ваш вопрос успешно создан!'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Non-authenticated user tries to create a question' do
    visit questions_path
    click_on 'Задать свой вопрос'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
