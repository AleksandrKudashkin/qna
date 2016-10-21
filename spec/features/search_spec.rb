require_relative 'feature_helper'

feature 'Full-text search', %q(
  In order to find an important information
  As a guest
  Or an authenticated user
  I want to be able to search through question, answers, comments and users
) do

  given!(:user) { create(:user, email: 'lorem@ipsum.com') }
  given!(:question) { create(:question, user: user, title: 'Lorem Ipsum Question') }
  given!(:question2) { create(:question, user: user, body: 'Lorem Ipsum Body') }
  given!(:answer) { create(:answer, user: user, question: question, body: 'Lorem Answer') }
  given!(:comment) { create(:comment, commentable: question, user: user, body: 'Lorem Comment') }
  given!(:comment2) { create(:comment, commentable: answer, user: user, body: 'Lorem2') }

  before { visit root_path }

  scenario 'guest sees a search form' do
    expect(page).to have_selector('#search_query')
  end

  scenario 'all search', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_query', with: 'Lorem'
      click_on 'Go'

      expect(page).to have_content question.title
      expect(page).to have_content question2.body
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content comment2.body
      expect(page).to have_content user.email
    end
  end

  scenario 'answer search', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_query', with: 'Lorem'
      select 'Answer', from: 'search_filter'
      click_on 'Go'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question2.body

      expect(page).to have_content answer.body
      expect(page).to have_link 'here', href: question_path(answer.question)

      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end
  end

  scenario 'comment search', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_query', with: 'Lorem'
      select 'Comment', from: 'search_filter'
      click_on 'Go'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question2.body
      expect(page).to_not have_content answer.body

      expect(page).to have_content comment.body
      expect(page).to have_link 'here', href: question_path(question)

      expect(page).to_not have_content user.email
    end
  end

  scenario 'comment to answer search', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_query', with: 'Lorem2'
      select 'Comment', from: 'search_filter'
      click_on 'Go'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question2.body
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body

      expect(page).to have_content comment2.body
      expect(page).to have_link 'here', href: question_path(question)

      expect(page).to_not have_content user.email
    end
  end

  scenario 'user search', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_query', with: 'Lorem'
      select 'User', from: 'search_filter'
      click_on 'Go'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question2.body
      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_link 'here'

      expect(page).to have_content user.email
    end
  end

  scenario 'question search', sphinx: true do
    ThinkingSphinx::Test.run do
      fill_in 'search_query', with: 'Lorem'
      select 'Question', from: 'search_filter'
      click_on 'Go'

      expect(page).to have_content question.title
      expect(page).to have_content question2.body
      expect(page).to have_link 'here', href: question_path(question)

      expect(page).to_not have_content answer.body
      expect(page).to_not have_content comment.body
      expect(page).to_not have_content user.email
    end
  end
end
