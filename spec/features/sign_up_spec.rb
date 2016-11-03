require_relative 'feature_helper'

feature 'User signs up', '
  In order to be able to ask a question
  As an User
  I want to be able to sign up to site
' do
  background do
    clear_emails
    visit new_user_registration_path
    fill_in 'Email', with: 'iam@theuser.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Register me!'
    open_email('iam@theuser.com')
  end

  scenario 'New user receives email with confirmations steps', :email do
    expect(current_email).to have_content 'You can confirm your account email through the link'
  end

  scenario 'New users confirms his accout', :email do
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed'
    expect(current_path).to eq new_user_session_path
  end
end
