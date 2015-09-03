require_relative 'feature_helper'

feature "Set best answer", %q{
    In order to let others know the best solution
    As an Authenticated user and author of question
    I want to be able to set an answer as a best answer
} do
  
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create_list(:answer, 3, question: question, user: user) }

  given(:f2_user) { create(:user) }
  given(:f2_question) { create(:question, user: f2_user) }
  given!(:f2_answer) { create(:answer, question: f2_question, user: user) }
  
  scenario 'Non-authenticated user tries to edit an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Лучший'
  end

  describe 'Authenticated user' do
    
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to set the best answer' do
      answer.each do |a|
        within ".answer-#{a.id}" do
          expect(page).to have_link 'Лучший'
        end  
      end
    end

    scenario 'dont see the link to set the best answer on not his question' do
      visit question_path(f2_question)
      
      within '.answers' do
        expect(page).to_not have_link 'Лучший'
      end
    end

    scenario 'tries to set the best answer', js: true do
      
      answer.sample do |a|
        within ".answer-#{a.id}" do
          click_on 'Лучший'
          expect(page).to have_css('best_answer')  
        end  
      end
    end

  end  
end