class UsersController < ApplicationController
  def index
    @users = User.all.order('created_at DESC').page(params[:page])
  end

  def show_mygadgets
    @user = User.find(params[:id])
    @gadgets = @user.gadgets
  end

  def show_favorites
    @user = User.find(params[:id])
    @gadgets = Gadget.joins(:likes).where(likes: { user_id: @user.id }).order('likes.created_at DESC')

  end

  def edit_profile
    @user = User.find(current_user.id)
  end

  def account
    @user = User.find(current_user.id)
  end
end
