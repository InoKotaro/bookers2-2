class BooksController < ApplicationController
  before_action :authenticate_user!, except: []
  before_action :test_edit, only:[:upadte, :edit, :destroy]

  def create
    @book= Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice]= "You have created book successfully."
      redirect_to book_path(@book)
    else
      @books= Book.all
      @user= current_user
      render :index
    end
  end

  def index
    @book= Book.new
    @books= Book.all
    @user= current_user
  end

  def show
    @book= Book.new#新規作成
    @book_show= Book.find(params[:id])#アソシ
    @user= @book_show.user#個別ユーザー情報
    @book_comment= Book.find(params[:id])#コメント
    @comment= Comment.new#コメント

  end

  def edit
    @book= Book.find(params[:id])
  end

  def update
    @book= Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice]= "You have created book successfully."
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def destroy
    @book= Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def test_edit
    @book= Book.find(params[:id])
    if(@book.user != current_user)
      redirect_to books_path
    end
  end



end
