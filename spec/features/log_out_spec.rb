require_relative 'feature_helper'

feature 'User log out', '
  In order to be able end my visit to this site
  As an User
  I want to be able to log out

' do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    visit root_path
    click_link 'Log out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
