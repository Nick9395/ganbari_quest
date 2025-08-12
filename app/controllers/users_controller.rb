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
      flash[:success] = t("flash.login_success")
      redirect_to user_path(@user)
    else
      flash.now[:custom_errors] = collect_custom_errors(@user) # サインインエラー表示
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
  # サインイン失敗時のエラーメッセージ処理
  def collect_custom_errors(user)
    messages = []

    messages << t("flash.register_errors.name_blank")if user.name.blank?
    messages << t("flash.register_errors.email_blank") if user.email.blank?
    messages << t("flash.register_errors.password_blank") if user.password.blank?
    messages << t("flash.register_errors.password_confirmation_blank") if user.password_confirmation.blank?

    # パスワード入力済みの内容チェック
    unless user.password.blank?
      if user.password.length < 4 || user.password.length > 12
        messages << t("flash.register_errors.password_length")
      end

      unless user.password.match(/\A[a-zA-Z0-9]+\z/)
        messages << t("flash.register_errors.password_format")
      end
    end

    # どれにも該当しない場合
    messages << t("flash.register_errors.default") if messages.empty?

    messages
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
