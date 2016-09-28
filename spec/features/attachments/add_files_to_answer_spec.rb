require_relative '../feature_helper'

feature 'Add files to answer', %q(
  In order to illustrate my answer
  As an author of a answer
  I want to be able to attach files
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds a file while asking a question', js: true do
    fill_in 'Your answer:', with: 'Read the following manual!'

    2.times { click_on 'Add a file' }

    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Save'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end
end
