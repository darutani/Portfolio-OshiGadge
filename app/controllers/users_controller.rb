class UsersController < ApplicationController
  def index
    @users = User.all.order('created_at DESC')
  end

  def show_mygadgets
    @user = User.find(params[:id])
    @gadgets = @user.gadgets
  end

  def show_favorites
    @user = User.find(params[:id])
    @gadgets = @user.gadgets
  end

  def edit_profile
    @user = User.find(current_user.id)
  end

  def account
  end
end
