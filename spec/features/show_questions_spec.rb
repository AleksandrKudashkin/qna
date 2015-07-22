require 'rails_helper'

feature 'Show questions index', %q{
  In order to find an interesting question
  As an non-authenticated or authenticated user
  I want to be able to view all the questions
} do

  given(:user) { create(:user) }
  given!(:f_questions) { create_list(:question, 5, user: user) }

  scenario 'Authenticated user views all the questions' do
    sign_in(user)

    visit questions_path

    f_questions.each do |q|
      expect(page).to have_content q.title
      expect(page).to have_content q.body
    end
    
  end

  scenario 'Non-authenticated user views all the questions' do

    visit questions_path

    expect(page).to have_content 'MyQuestionText'
  end
end

