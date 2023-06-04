class GadgetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destory]
  before_action :set_gadget, only: %i[ show edit update destroy ]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def top
    @gadgets = Gadget.all.order('created_at DESC').limit(9)
    @users = User.all.order('created_at DESC').limit(9)
  end

  def index
    @gadgets = Gadget.all.order('created_at DESC').page(params[:page]).per(24)
    @gadgets_new_order = Gadget.all.order('created_at DESC').page(params[:page])
    @gadgets_older_order = Gadget.all.order('created_at ASC').page(params[:page])
    @gadgets_ranking_order = Gadget.left_joins(:likes).group(:id).order('COUNT(likes.id) DESC').page(params[:page])
    @gadgets_name_asc_order = Gadget.order('name ASC').page(params[:page])
    @gadgets_name_desc_order = Gadget.order('name DESC').page(params[:page])
    @gadgets_category_asc_order = Gadget.order('category_list ASC').page(params[:page])
    @gadgets_category_desc_order = Gadget.order('category_list DESC').page(params[:page])
  end

  def show
    @gadget = Gadget.find(params[:id])
    @comment = Comment.new
    @comments = @gadget.comments.order('created_at ASC').limit(5)
  end

  def new
    @gadget = Gadget.new
  end

  def edit
  end

  def create
    @gadget = Gadget.new(gadget_params)
    if @gadget.save
      redirect_to gadget_url(@gadget), notice: "新規ガジェットを登録しました"
    else
      render :new
    end
  end

  def update
    if @gadget.update(gadget_params)
      redirect_to gadget_url(@gadget), notice: "ガジェット情報を更新しました"
    else
      render :new
    end
  end

  def destroy
    flash[:notice] = "ガジェットを削除しました"
    @gadget.destroy
    respond_to do |format|
      format.html { redirect_to mygadgets_user_path(current_user.id), notice: "ガジェットを削除しました" }
      format.json { head :no_content }
    end
  end

  def liked_users
    @gadget = Gadget.find(params[:id])
    @users = User.joins(:likes).where(likes: { gadget_id: @gadget.id }).order('likes.created_at DESC').page(params[:page])
  end

  def search_rakuten
    if params[:q].present?
      @rakuten_items = RakutenWebService::Ichiba::Item.search(keyword: params[:q])
    end
    respond_to do |format|
      format.js
    end
  end

  private
    def set_gadget
      @gadget = Gadget.find(params[:id])
    end

    def gadget_params
      params.require(:gadget).permit(:user_id, :name, :start_date, :category_list, :reason, :point, :usage, :image, :rakuten_url).merge(user_id:current_user.id)
    end

    def ensure_correct_user
      if @gadget.user_id != current_user.id
        flash[:alert] = "権限がありません"
        redirect_to gadget_path
      end
    end
end
