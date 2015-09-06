require_relative 'feature_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an author of a answer
  I want to be able to attach files
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds a file while asking a question' do
    fill_in 'Ваш ответ', with: 'Read the following manual!'
    attach_file 'Прикрепить файл:', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Сохранить'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end