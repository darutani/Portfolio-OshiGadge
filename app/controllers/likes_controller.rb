class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @gadget = Gadget.find(params[:gadget_id])
    @like = current_user.likes.create(gadget_id: params[:gadget_id])
    @custom_view = params[:custom_view]
    @like.save

    respond_to do |format|
      if @like.save
        format.html { redirect_to @gadget, notice: 'Liked the gadget.' }
        format.js
      else
        format.html { redirect_to @gadget, alert: 'Failed to like the gadget.' }
        format.js { render :error }
      end
    end
  end

  def destroy
    @gadget = Gadget.find(params[:gadget_id])
    @like = current_user.likes.find_by(gadget_id: params[:gadget_id])
    @custom_view = params[:custom_view]
    @like.destroy

    respond_to do |format|
      format.html { redirect_to @gadget, notice: 'Unliked the gadget.' }
      format.js
    end
  end
end
