class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def create
    @gadget = Gadget.find(params[:gadget_id])
    @comment = @gadget.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      if request.referer.include?("comments")
        redirect_to gadget_comments_path(@gadget)
      else
        redirect_to gadget_path(@gadget)
      end
    else
      flash[:alert] = "コメントの投稿に失敗しました。"
      @gadget.comments.delete(@comment)
      if request.referer.include?("comments")
        render 'comments/index'
      else
        render 'gadgets/show'
      end
    end
  end

  def destroy
    @gadget = Gadget.find(params[:gadget_id])
    @comment = @gadget.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      if request.referer.include?("comments")
        redirect_to gadget_comments_path(@gadget)
      else
        redirect_to gadget_path(@gadget)
      end
    end
  end

  def index
    @gadget = Gadget.find(params[:gadget_id])
    @comment = Comment.new
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
