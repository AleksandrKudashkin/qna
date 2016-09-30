require_relative 'feature_helper'

feature 'User signs in with facebook account', '
  In order to login quickly
  As an Guest
  Or as an User
  I want to be able to sign in via facebook
' do

  describe 'access to questions index' do
    background do
      visit root_path
      click_on 'Sign in'
      mock_auth_facebook_hash
    end

    scenario 'user sees the link to facebook login' do
      expect(page).to have_link 'Sign in with Facebook'
    end

    scenario 'non-existing user tries to sign in via facebook' do
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account'
      expect(page).to have_link 'Log out'
      expect(current_path).to eq root_path
    end

    context 'existing user' do
      let!(:user) { create(:user, email: 'mock@user.com') }

      scenario 'existing user tries to sign in via facebook' do
        click_on 'Sign in with Facebook'
        expect(page).to have_content 'Successfully authenticated from Facebook account'
        expect(page).to have_link 'Log out'
        expect(current_path).to eq root_path
      end
    end

    scenario "can handle authentication error" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_on 'Sign in with Facebook'
      expect(page).to have_content('Could not authenticate you from Facebook')
      expect(page).to have_content('Invalid credentials')
    end
  end
end
