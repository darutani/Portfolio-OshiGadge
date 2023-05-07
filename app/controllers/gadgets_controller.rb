class GadgetsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destory]
  before_action :set_gadget, only: %i[ show edit update destroy ]

  def top
    @gadgets = Gadget.all.order('created_at DESC').limit(10)
    @users = User.all.order('created_at DESC').limit(10)
  end

  def index
    @gadgets = Gadget.all.order('created_at DESC').page(params[:page])
  end

  def show
    @gadget = Gadget.find(params[:id])
    @comments = @gadget.comments.order('created_at ASC').limit(5)
  end

  def new
    @gadget = Gadget.new
  end

  def edit
  end

  def create
    @gadget = Gadget.new(gadget_params)

    respond_to do |format|
      if @gadget.save
        format.html { redirect_to gadget_url(@gadget), notice: "新規ガジェットを登録しました" }
        format.json { render :show, status: :created, location: @gadget }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gadget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gadgets/1 or /gadgets/1.json
  def update
    respond_to do |format|
      if @gadget.update(gadget_params)
        format.html { redirect_to gadget_url(@gadget), notice: "ガジェット情報を更新しました" }
        format.json { render :show, status: :ok, location: @gadget }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gadget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gadgets/1 or /gadgets/1.json
  def destroy
    @gadget.destroy

    respond_to do |format|
      format.html { redirect_to gadgets_url, notice: "Gadget was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def liked_users
    @gadget = Gadget.find(params[:id])
    @users = User.joins(:likes).where(likes: { gadget_id: @gadget.id }).order('likes.created_at DESC').page(params[:page])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gadget
      @gadget = Gadget.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gadget_params
      params.require(:gadget).permit(:user_id, :name, :start_date, :category, :reason, :point, :usage, :image).merge(user_id:current_user.id)
    end
end
