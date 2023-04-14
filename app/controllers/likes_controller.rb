class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @gadget = Gadget.find(params[:gadget_id])
    current_user.likes.create!(gadget: @gadget)
    redirect_to @gadget
  end

  def destroy
    @gadget = Gadget.find(params[:gadget_id])
    current_user.likes.find_by(gadget_id: @gadget.id).destroy!
    redirect_to @gadget
  end
end
