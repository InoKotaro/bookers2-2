class CommentsController < ApplicationController

  def create
    book= Book.find(params[:book_id])#コメント
    #comment= current_user.comment.new(commnet_params)省略ver.
    comment= Comment.new(comment_params)#コメント
    comment.user_id= current_user.id#ログイン中ユーザーに特定
    comment.book_id= book.id#4行目で取得した本に特定
    comment.save
    redirect_to request.referer#元居たページに戻る
  end

  def destroy
    Comment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    redirect_to request.referer
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end