class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    if @attachment.attachable.user_id == current_user.id
      @attachment.destroy ? flash[:warning] = 'Ваш файл удалён!' : flash.now[:danger] = 'Ошибка! Не удалось удалить Ваш файл!'
    end
  end

  private
    def find_attachment
      @attachment = Attachment.find(params[:id])
    end
end
