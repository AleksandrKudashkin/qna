require 'rails_helper'

feature 'Show questions index', %q{
  In order to find an interesting question
  As an non-authenticated or authenticated user
  I want to be able to view all the questions
} do

  given(:user) { create(:user) }
  before { 5.times { create(:question) } }

  scenario 'Authenticated user views all the questions' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content 'MyQuestionText'
  end

  scenario 'Non-authenticated user views all the questions' do

    visit questions_path

    expect(page).to have_content 'MyQuestionText'
  end
end

