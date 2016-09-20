require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:f_user) { create(:user) }
  let!(:f_question) { create(:question, user: f_user) }
  let!(:f_attachment) { create(:attachment, attachable: f_question) }

  let(:f2_user) { create(:user) }
  let!(:f2_question) { create(:question, user: f2_user) }
  let!(:f2_attachment) { create(:attachment, attachable: f2_question) }

  let!(:answer) { create(:answer, question: f_question, user: f2_user) }
  let!(:answer_file) { create(:attachment, attachable: answer) }

  before { sign_in(f_user) }

  describe 'DELETE #destroy' do
    it 'deletes the attachment of the question' do
      expect do
        delete :destroy, id: f_attachment, format: :js
      end.to change(f_question.attachments, :count).by(-1)
    end

    it 'renders destroy js template' do
      delete :destroy, id: f_attachment, format: :js
      expect(response).to render_template :destroy
    end

    it 'not deletes the files of the other user' do
      expect do
        delete :destroy, id: f2_attachment, format: :js
      end.to_not change(f_question.attachments, :count)
    end

    it 'deletes the file of the answer' do
      sign_in(f2_user)
      expect do
        delete :destroy, id: answer_file, format: :js
      end.to change(answer.attachments, :count).by(-1)
    end
  end
end
