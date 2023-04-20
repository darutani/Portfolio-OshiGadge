class RelationshipsController < ApplicationController
  before_action :authenticate_user!, only: %i[ create destroy ]

  def create
    @user_to_follow = User.find(params[:user_id])
    current_user.follow(@user_to_follow)

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def destroy
    @user_to_unfollow = User.find(params[:user_id])
    current_user.unfollow(@user_to_unfollow)

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  # フォロー一覧
  def followings
    @user = User.find(params[:user_id])
    @users = @user.followings.page(params[:page])
  end

  # フォロワー一覧
  def followers
    @user = User.find(params[:user_id])
    @users = @user.followers.page(params[:page])
  end
end
