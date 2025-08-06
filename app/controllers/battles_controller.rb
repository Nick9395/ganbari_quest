class BattlesController < ApplicationController
  before_action :set_user
  before_action :initialize_session

  def index
    # 選択された日付を受け取る（なければ今日）
    # @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    begin
      @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    rescue ArgumentError
      @selected_date = Date.current
    end

    # セッションに日付を記録
    session[:last_selected_date] = @selected_date.to_s

    # dbに保管されている経験値の合計
    @base_experience = @user.scores.sum(:experience)

    # セッションの増減値
    session[:exp_diff] ||= 0

    # 表示用の最終経験値（DB+セッション値）
    @experience = @base_experience + session[:exp_diff]
    @experience = 0 if @experience < 0 # マイナスにならないために

    @level = (@experience / 8) + 1
    @next_level_exp = (@level * 8) - @experience
  end

  def increase
    # セッション初期化
    session[:exp_diff] ||= 0

    # DBの合計経験値（レベル計算の基準）
    base_exp = @user.scores.sum(:experience)
    previous_total_exp = base_exp + session[:exp_diff]

    # 経験値を +1
    session[:exp_diff] += 1
    new_total_exp = base_exp + session[:exp_diff]

    # レベル判定
    previous_level = (previous_total_exp / 8) + 1
    new_level = (new_total_exp / 8) + 1

    flash[:rpg] = [
      "ゆうしゃのこうげき！<br>本日のかだいをやっつけた<br>ゆうしゃは1のけいけんちをえた<br>",
      "かいしんのいちげき！<br>本日のかだいをやっつけた<br>ゆうしゃは1のけいけんちをえた<br>",
      "ゆうしゃはメラゾーマをとなえた<br>本日のかだいをやっつけた<br>ゆうしゃは1のけいけんちをえた<br>",
      "ゆうしゃの超究武神覇斬！！<br>本日のかだいをやっつけた<br>ゆうしゃは1のけいけんちをえた<br>",
      "ゆうしゃのエース・オブ・ザ・ブリッツ！！<br>本日のかだいをやっつけた<br>ゆうしゃは1のけいけんちをえた<br>",
      "ゆうしゃのつるのむち<br>本日のかだいをやっつけた<br>ゆうしゃは1のけいけんちをえた<br>"
  ].sample
    # session[:experience] = 7984 if session[:experience] > 7984

    if new_level > previous_level
      flash[:rpg2] = "ゆうしゃはレベルが上がった！"
      flash[:levelup] = true
    end

    redirect_to user_battles_path(@user, date: params[:date] || session[:last_selected_date])
  end

  def decrease
    # セッション初期化
    session[:exp_diff] ||= 0

    # 表示のためにdbから現在の合計経験値を取得
    base_exp = @user.scores.sum(:experience)
    previous_total_exp = base_exp + session[:exp_diff]

    session[:exp_diff] -= 1

    # 下限を 0 に保つ
    if (base_exp + session[:exp_diff]) < 0
      session[:exp_diff] = -base_exp
    end

    new_total_exp = base_exp + session[:exp_diff]

    previous_level = (previous_total_exp / 8) + 1
    new_level = (new_total_exp / 8) + 1

    flash[:rpg] = "ゆうしゃはなまけた<br>けいけんちが1下がった<br>"
    if new_level < previous_level

    flash[:rpg3] = [
      "ゆうしゃはレベルが下がった<br>ドンマイ(笑)",
      "ゆうしゃはレベルが下がった・・・<br>そんな日もあるさ",
      "ゆうしゃはレベルが下がった<br>次がんばろう",
      "ゆうしゃはレベルが下がった<br>ここからばんかいだ"
      ].sample
      flash[:leveldown] = true
    end

    redirect_to user_battles_path(@user, date: params[:date] || session[:last_selected_date])
  end

  def save_score
    recorded_on = params[:date].presence || session[:last_selected_date] || Date.current
    recorded_on = Date.parse(recorded_on.to_s)

    exp_diff = session[:exp_diff] || 0 # セッションに保存された増減値を使う

    Rails.logger.debug "[DEBUG] save_score: exp_diff=#{exp_diff}"

    return redirect_to user_path(@user) if exp_diff == 0

    base_exp = @user.scores.sum(:experience)
    exp_diff = -base_exp if base_exp + exp_diff < 0 # 合計値がマイナスにならないよう調整

    score = Score.find_or_initialize_by(user_id: @user.id, recorded_on: recorded_on)
    score.experience ||= 0
    score.experience += exp_diff

    if score.save

      Rails.logger.debug "[DEBUG] save_score: save successful"

      # セッションをリセット（必要に応じて）
      session[:exp_diff] = 0
      session[:last_selected_date] = nil
      redirect_to user_path(@user)
    else

      Rails.logger.debug "[DEBUG] save_score: save FAILED"

      redirect_to user_battles_path(@user, date: recorded_on)
    end
  end

  def escape
    # セッションの経験値差分をリセット（バトル画面からにげる）
    session[:exp_diff] = 0
    redirect_to user_path(@user, date: params[:date] || session[:last_selected_date])
  end

  private

  def initialize_session
    session[:experience] ||= 0
  end

  def set_user
    unless current_user
      flash[:danger] = "[警告] 不正なアクセスです"
      redirect_to root_path
      return
    end

    if params[:user_id].to_i != current_user.id
      flash[:danger] = "[警告] 不正なアクセスです"
      redirect_to root_path
    else
      @user = current_user
    end
  end
end
