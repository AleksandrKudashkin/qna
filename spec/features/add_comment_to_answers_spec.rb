require_relative 'feature_helper'

feature 'Add comment for answer', %q(
  In order to give additional information to the answer
  As an authenticated user
  I want to be able to add a comment to the answer
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  let(:new_answer_comment_selector) { ".new-answer-comment-#{answer.id}" }

  describe "Non-authenticated user" do
    scenario "doesn't see the form to comment" do
      visit(question_path(question))
      expect(page).to_not have_selector(new_answer_comment_selector)
    end
  end

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit(question_path(question))
    end

    scenario "sees the form to comment" do
      expect(page).to have_selector(new_answer_comment_selector)
    end

    scenario "leaves a comment", js: true do
      within(".new-answer-comment-#{answer.id}") do
        fill_in 'comment_body', with: "My first answer comment!"
        click_on "Send"
      end
      expect(page).to have_content("My first answer comment!")
      within(".new-answer-comment-#{answer.id}") do
        expect(find_field('comment[body]').value).to eq ''
      end
    end

    scenario "makes an invalid comment", js: true do
      within(".new-answer-comment-#{answer.id}") do
        fill_in 'comment_body', with: ''
        click_on "Send"
      end
      expect(page).to have_content("Body can't be blank")
    end
  end
end
