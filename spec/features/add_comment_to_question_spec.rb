require_relative 'feature_helper'

feature 'Add comment for question', %q(
  In order to give additional information to the question
  As an authenticated user
  I want to be able to add a comment to the question
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe "Non-authenticated user" do
    scenario "doesn't see the form to comment" do
      visit(question_path(question))
      expect(page).to_not have_selector(".new-question-comment")
    end
  end

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit(question_path(question))
    end

    scenario "sees the form to comment" do
      expect(page).to have_selector(".new-question-comment")
    end

    scenario "makes an invalid comment", js: true do
      fill_in 'comment_body', with: ''
      click_on "Send"
      expect(page).to have_content("Body can't be blank")
    end

    scenario "leaves a comment", js: true do
      within('.new-question-comment') do
        fill_in 'comment_body', with: "My first comment!"
        click_on "Send"
      end
      expect(page).to have_content("My first comment!")
      within('.new-question-comment') do 
        expect(find_field('comment[body]').value).to eq ''
      end
    end
  end
end
