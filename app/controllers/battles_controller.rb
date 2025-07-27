class BattlesController < ApplicationController
  before_action :set_user
  before_action :initialize_session

  def index
    @battles = @user.battles
    @experience = session[:experience]
    @level = session[:level]
  end

  def increase
    session[:experience] ||= 1
    session[:level] ||= 1

    previous_exp = session[:experience]
    session[:experience] += 1
    session[:experience] = 7984 if session[:experience] > 7984

    new_level = (session[:experience] / 8) + 1
    previous_level = (previous_exp / 8) + 1

    if new_level > previous_level
      flash[:rpg] = "本日の課題をやっつけた。勇者はレベルが上がった！"
      flash[:levelup] = true
    end

    session[:level] = new_level
    redirect_to user_battles_path(@user)
  end

  def decrease
    session[:experience] ||= 1
    session[:level] ||= 1

    previous_exp = session[:experience]
    session[:experience] -= 1
    session[:experience] = 1 if session[:experience] < 1

    new_level = (session[:experience] / 8) + 1
    previous_level = (previous_exp / 8) + 1

    if new_level < previous_level
      flash[:rpg] = "勇者はなまけた。レベルが下がった(笑)"
      flash[:leveldown] = true
    end

    session[:level] = new_level
    redirect_to user_battles_path(@user)
  end

  def save_score
    score = Score.find_or_initialize_by(
      user_id: @user.id,
      recorded_on: Date.current
    )

    score.experience = session[:experience]
    if score.save
      redirect_to user_path(@user), success: 'スコアを保存しました（上書き）'
    else
      redirect_to user_battles_path(@user), alert: 'スコアの保存に失敗しました'
    end
  end

  private

  def initialize_session
    session[:experience] ||= 1
    session[:level] ||= 1
  end

  def set_user
    if params[:user_id].to_i != current_user.id
      redirect_to root_path, danger: "不正なアクセスです"
    else
      @user = current_user
    end
  end
end