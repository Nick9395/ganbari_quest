class UsersController < ApplicationController
  before_action :require_login, only: %i[ show ] # showページはログイン必須
  def new
    @user = User.new
  end

  # ユーザー登録
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user) # notice: 'sign up'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # ユーザー情報表示
  def show
    @user = User.find(params[:id])

    # 他人のページにアクセスした場合の制限
    unless @user ==current_user
      redirect_to root_path # alert: 'can not access'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
