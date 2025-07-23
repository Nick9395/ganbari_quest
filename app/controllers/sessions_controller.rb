class SessionsController < ApplicationController
  def new
  end

  # ログイン管理
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user) # notice: 'login'
    else
      # flash.now[:alert] = 'not login'
      render :new, status: :unprocessable_entity
    end
  end

  # ログアウト管理
  def destroy
    session[:user_id] = nil
    redirect_to root_path # notice: 'logout'
  end
end
