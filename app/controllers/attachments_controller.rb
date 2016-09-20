class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment

  def destroy
    return unless current_user.author_of?(@attachment.attachable)
    if @attachment.destroy
      flash[:warning] = 'Your file has been deleted!'
    else
      flash.now[:danger] = 'Error! Your file has not been deleted!'
    end
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
