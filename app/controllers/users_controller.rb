class UsersController < ApplicationController
  before_action :require_login, only: %i[ show ] # showページはログイン必須

  def index
    redirect_to new_user_path
  end

  def new
    @user = User.new
  end

  # ユーザー登録
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
      flash[:success] = '勇者が召喚された'
    else
      flash.now[:danger] = 'アカウント作成に失敗しました'
      flash.now[:rpg] = '勇者の召喚に失敗した'
      render :new, status: :unprocessable_entity
    end
  end

  # ユーザー情報表示
  def show
    @user = User.find(params[:id])

    @experience = @user.scores.sum(:experience)
    @experience = 1 if @experience < 1 # マイナスやゼロにならないために

    @level = (@experience / 8) + 1
    @next_level_exp = ((@level * 8) + 1) - @experience

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
