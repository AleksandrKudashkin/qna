require_relative 'feature_helper'

feature 'Add files to question', %q(
  In order to illustrate my question
  As an author of a question
  I want to be able to attach files
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds a file while asking a question', js: true do
    fill_in 'Title:', with: question.title
    fill_in 'Description:', with: question.body

    2.times { click_on 'Add a file' }

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Save'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
