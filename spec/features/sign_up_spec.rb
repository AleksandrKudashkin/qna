require_relative 'feature_helper'

feature 'User signs up', '
  In order to be able to ask a question
  As an User
  I want to be able to sign up to site

' do
  scenario 'Registered user tries to sign in' do
    visit new_user_registration_path
    fill_in 'Email', with: 'iam@theuser.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Register me!'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end
end
