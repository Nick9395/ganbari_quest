class SessionsController < ApplicationController
  def new
  end

  # ログイン管理
  def create
    email = params[:email]
    password = params[:password]
    if email.blank?
      password.blank?
      flash.now[:danger] = "メールアドレスとパスワードを入力してください"
    elsif email.blank?
      flash.now[:danger] = "メールアドレスを入力してください"
    elsif password.blank?
      flash.now[:danger] = "パスワードを入力して下さい"

    else
      user = User.find_by(email: email)

      if user&.authenticate(password)
        session[:user_id] = user.id
        flash[:status] = "login_success" # 成功時フラッシュの内容をトリガーに成功音が発動
        flash[:success] = t("flash.login_success")
        redirect_to user_path(user) and return
      else
        flash.now[:danger] = "メールアドレスまたはパスワードが正しくありません"
      end
    end

    render :new, status: :unprocessable_entity
  end

  # ログアウト管理
  def destroy
    email = current_user&.email
    reset_session
    redirect_to login_path(email: email) # notice: 'logout'
  end
end
