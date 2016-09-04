require_relative 'feature_helper'

feature "Voting for question", %q{
  In order to give my opinion for the value of the question
  As an authenticated user
  I want to be able to vote up or down for the question
} do     
  
  given(:user) { create(:user) }  
  given(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given(:third_user) { create(:user) }

  def links_test(have_rights=false)
    visit question_path(question)
    within ".question-votes" do
      if have_rights 
        expect(page).to have_selector :link_or_button, "q-vote-up"
        expect(page).to have_selector :link_or_button, "q-vote-down"
        expect(page).to_not have_selector :link_or_button, "q-cancel-vote"
      else
        expect(page).to_not have_selector :link_or_button, "q-vote-up"
        expect(page).to_not have_selector :link_or_button, "q-vote-down"
      end
    end  
  end

  describe 'Cannot vote' do
    scenario 'Non-authenticated user doesnt see the link to vote' do
      links_test
    end

    scenario 'Author doesnt see the link to vote' do
      sign_in(user)
      links_test
    end
  end

  describe 'Can vote' do
    before { sign_in(other_user) }

    scenario 'The other user votes up for the question', js:true do
      links_test(true)
      click_on "q-vote-up"
      within ".q-rating" do
        expect(page).to have_content 'рейтинг: 1'
      end
      links_test
    end

    scenario 'The other user votes up for the question', js:true do
      links_test(true)
      click_on "q-vote-down"
      within ".q-rating" do
        expect(page).to have_content 'рейтинг: -1'
      end
      links_test
    end

    scenario 'The other user cancels his vote for the question', js:true do
      visit question_path(question)
      click_on "q-vote-up"
      links_test
      expect(page).to have_selector :link_or_button, "q-cancel-vote"

      click_on "q-cancel-vote"
      links_test(true)      
    end
  end

  describe 'Multiple vote' do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    scenario 'The two users vote up for the question', js:true do
      click_on "q-vote-up"
      
      click_on 'Log out'
      sign_in(third_user)
      visit question_path(question)
      click_on "q-vote-up"

      within ".q-rating" do
        expect(page).to have_content 'рейтинг: 2'
      end      
    end

    scenario 'The two users vote down for the question', js:true do
      click_on "q-vote-down"
      
      click_on 'Log out'
      sign_in(third_user)
      visit question_path(question)
      click_on "q-vote-down"

      within ".q-rating" do
        expect(page).to have_content 'рейтинг: -2'
      end      
    end
  end
end
