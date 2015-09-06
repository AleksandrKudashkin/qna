require_relative 'feature_helper'

feature 'Delete files from question', %q{
  In order to delete wrong attachments
  As an author of a question
  I want to be able to delete attached files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }
  given(:other_user) { create(:user) }
  
  describe 'Author logged in and' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees the links to delete files' do
      expect(page).to have_link "Удалить файл", href: attachment_path(attachment)
    end

    scenario 'deletes his file', js: true do
      click_link "delete-file-#{attachment.id}"
      within '.question' do
        expect(page).to_not have_link attachment.file.identifier
      end
    end
  end

  scenario 'Other user tries to delete a file from question' do
    sign_in(other_user)
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Удалить файл'
    end
  end

  scenario 'Non-authenticated user tries to delete a file from question' do
    visit question_path(question)

    expect(page).to_not have_link 'Удалить файл'
  end
end