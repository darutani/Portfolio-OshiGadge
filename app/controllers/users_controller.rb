class UsersController < ApplicationController
  def index
  end

  def show_mygadgets
  end

  def show_favorites
  end

  def edit_profile
    @user = User.find(current_user.id)
  end

  def account
  end
end
