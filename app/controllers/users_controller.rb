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
      flash[:success] = t("flash.login_success")
    else
      # flash.now[:errors] = @user.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  # ユーザー情報表示
  def show
    @user = User.find(params[:id])
    @current_month = Date.today.beginning_of_month

    # 「にげる」以外でuser/showに戻ってきた場合のセッションをリセット
    session[:exp_diff] ||=0

    # 経験値やレベルのトータル？
    @experience = [ @user.scores.sum(:experience), 0 ].max
    @level = (@experience / 8) + 1
    @next_level_exp = (@level * 8) - @experience

    # 他人のページにアクセスした場合の制限 ※修正中
    unless @user == current_user
      flash[:danger] = "[警告] 不正なアクセスです"
      redirect_to root_path and return
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
