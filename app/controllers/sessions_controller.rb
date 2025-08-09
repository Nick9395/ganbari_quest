class SessionsController < ApplicationController
  def new
  end

  # ログイン管理
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "login_success" # 成功時フラッシュの内容をトリガーに成功音が発動
      redirect_to user_path(user) # notice: 'login'
    else
      flash.now[:danger] = "not login ログインできませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  # ログアウト管理
  def destroy
    email = current_user&.email
    reset_session
    redirect_to login_path(email: email) # notice: 'logout'
  end
end
