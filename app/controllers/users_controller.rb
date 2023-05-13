class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit_profile, :account]
  before_action :ensure_correct_user, only: [:edit_profile, :account]

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

  private

  def ensure_correct_user
    if current_user.id != params[:id].to_i
      flash[:alert] = "権限がありません"
      redirect_to root_path
    end
  end
end
