require_relative 'feature_helper'

feature "Voting for answer", %q{
  In order to give my opinon for the value of the answer
  As an authenticated user
  I want to be able to vote up or down for the answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:third_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: other_user ) }
  given!(:second_answer) { create(:answer, question: question, user: third_user) }

  
  def links_test(answer, have_rights=false)
    visit question_path(question)
    within ".answer-#{answer.id}" do
      if have_rights 
        expect(page).to have_selector :link_or_button, "a-vote-up"
        expect(page).to have_selector :link_or_button, "a-vote-down"
        expect(page).to_not have_selector :link_or_button, "a-cancel-vote"
      else
        expect(page).to_not have_selector :link_or_button, "a-vote-up"
        expect(page).to_not have_selector :link_or_button, "a-vote-down"
      end
    end  
  end
  
  describe 'Vote restricted' do
    scenario 'Non-authenticated user doesnt see the link to vote' do
      visit question_path(question)
      expect(page).to_not have_selector :link_or_button, "a-cancel-vote"
      links_test(answer)
      links_test(second_answer)
    end
    
    scenario 'Author of the answer doesnt see the link to vote' do
      sign_in(other_user) 
      expect(page).to_not have_selector :link_or_button, "a-cancel-vote"
      visit question_path(question)
      links_test(answer)
    end
  end 

  describe 'Vote allowed' do
    before do
      sign_in(third_user)
      visit question_path(question)
    end

    scenario 'The user votes up for the answer', js: true do
      links_test(answer, true)
      within ".answer-#{answer.id}" do
        click_on "a-vote-up"
      end
      within ".a-rating-#{answer.id}" do
        expect(page).to have_content 'рейтинг: 1'
      end   
    end

    scenario 'The user votes down for the answer', js: true do
      links_test(answer, true)
      within ".answer-#{answer.id}" do
        click_on "a-vote-down"
      end
      within ".a-rating-#{answer.id}" do
        expect(page).to have_content 'рейтинг: -1'
      end
    end

    scenario 'Two users votes up for the answer', js: true do
      within ".answer-#{answer.id}" do
        click_on "a-vote-up"
      end

      click_on 'Log out'
      sign_in(user)
      visit question_path(question)      

      within ".answer-#{answer.id}" do
        click_on "a-vote-up"
      end

      within ".a-rating-#{answer.id}" do
        expect(page).to have_content 'рейтинг: 2'
      end
    end

    scenario 'Two users votes down for the answer', js: true do
      within ".answer-#{answer.id}" do
        click_on "a-vote-down"
      end

      click_on 'Log out'
      sign_in(user)
      visit question_path(question)      

      within ".answer-#{answer.id}" do
        click_on "a-vote-down"
      end

      within ".a-rating-#{answer.id}" do
        expect(page).to have_content 'рейтинг: -2'
      end
    end

    scenario 'The user cancels his vote', js: true do
      within ".answer-#{answer.id}" do
        click_on "a-vote-up"
      end

      click_on 'Log out'
      sign_in(user)
      visit question_path(question)      

      within ".answer-#{answer.id}" do
        click_on "a-vote-up"
        click_on "a-cancel-vote"
      end

      links_test(answer, true)
      within ".a-rating-#{answer.id}" do
        expect(page).to have_content 'рейтинг: 1'
      end
    end
  end
  
end
