require_relative '../feature_helper'

feature 'Delete files from question', %q(
  In order to delete wrong attachments
  As an author of a question
  I want to be able to delete attached files
) do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:user2) { create(:user) }
  given(:answer) { create(:answer, user: user2, question: question) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  describe 'Author of answer logged in and' do
    background do
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'sees the links to delete files' do
      within ".answer-#{answer.id}" do
        expect(page).to have_link("delete-file-#{attachment.id}", href: attachment_path(attachment))
      end
    end

    scenario 'deletes his file', js: true do
      click_link "delete-file-#{attachment.id}"
      within ".answer-#{answer.id}" do
        expect(page).to_not have_link attachment.file.identifier
      end
    end
  end

  scenario 'Other user tries to delete a file from answer' do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Удалить файл'
    end
  end

  scenario 'Non-authenticated user tries to delete a file from answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Удалить файл'
  end
end
