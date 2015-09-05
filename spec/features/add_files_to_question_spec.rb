require_relative 'feature_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of a question
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds a file while asking a question' do
    fill_in 'Заголовок:', with: question.title
    fill_in 'Опишите свой вопрос подробнее:', with: question.body
    attach_file 'Прикрепить файл:', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Сохранить'
    expect(page).to have_content 'spec_helper.rb'
  end
end