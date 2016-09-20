require_relative 'feature_helper'

feature 'View questions and answers', %q(
  In order to get information for my problem
  As an non-authenticated or authenticated user
  I want to be able to view the content of question and answers for it
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Authenticated user views a question with answers' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answer.each { |a| expect(page).to have_content a.body }
  end

  scenario 'Non-authenticated user views a question with answers' do
    visit question_path(question)

    expect(page).to have_content 'MyQuestionText'
    expect(page).to have_content 'Read the following manual'
  end
end
