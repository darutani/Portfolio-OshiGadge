class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def create
    @gadget = Gadget.find(params[:gadget_id])
    @comment = @gadget.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to gadget_path(@gadget)
    else
      flash[:alert] = "コメントの投稿に失敗しました。"
      render 'gadgets/show'
    end
  end

  def destroy
    @gadget = Gadget.find(params[:gadget_id])
    @comment = @gadget.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      # 成功時の処理
    else
      # 失敗時の処理
    end
  end

  def index
    @gadget = Gadget.find(params[:gadget_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def ensure_correct_user
    comment = Comment.find(params[:id])
    unless comment.user_id == current_user.id
      flash[:alert] = "権限がありません。"
      redirect_to(root_path)
    end
  end
  
end
