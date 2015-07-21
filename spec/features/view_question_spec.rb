require 'rails_helper'

feature 'View questions and answers', %q{
  In order to get information for my problem
  As an non-authenticated or authenticated user
  I want to be able to view the content of question and answers for it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user views a question with answers' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content 'MyQuestionText'
    expect(page).to have_content 'Read the following manual'
  end

  scenario 'Non-authenticated user views a question with answers' do
    visit question_path(question)

    expect(page).to have_content 'MyQuestionText'
    expect(page).to have_content 'Read the following manual'
  end
end