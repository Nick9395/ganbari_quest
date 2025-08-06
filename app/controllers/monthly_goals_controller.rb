class MonthlyGoalsController < ApplicationController
  before_action :set_user
  before_action :set_month

  def new
    @monthly_goal = @user.monthly_goals.find_or_initialize_by(month: @month)
  end

  def create
    @monthly_goal = @user.monthly_goals.find_or_initialize_by(month: @month)
    @monthly_goal.assign_attributes(monthly_goal_params)
    @monthly_goal.month = @month

    if @monthly_goal.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    @monthly_goal = @user.monthly_goals.find_by(month: @month) || @user.monthly_goals.build(month: @month)

    # 該当月の開始日と終了日を定義
    start_date = @month.beginning_of_month
    end_date = @month.end_of_month


    # ユーザーごとに（@user）スコアのある日を取得
    raw_scores = @user.scores
                      .where(recorded_on: start_date..end_date)
                      .group(:recorded_on)
                      .sum(:experience)

    # 1日〜末日までの全日を0で初期化
    @experience_data = (start_date..end_date).map do |date|
      [ date.day.to_s, raw_scores[date] || 0 ]
    end
  end

  def update
    @monthly_goal = @user.monthly_goals.find(params[:id])
    @monthly_goal.assign_attributes(monthly_goal_params)
    @monthly_goal.month = @month

    if @monthly_goal.save
      flash[:success] = "更新しました"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_month
    if params[:month].present? && params[:month] =~ /\A\d{4}-\d{2}-\d{2}\z/
      # 形式が "YYYY-MM-DD" ならそのままパース
      @month = Date.parse(params[:month]).beginning_of_month rescue Date.today.beginning_of_month
    elsif params[:year].present? && params[:month].present?
      # 年と月が個別に来た場合（セレクトタグ）
      @month = Date.new(params[:year].to_i, params[:month].to_i, 1) rescue Date.today.beginning_of_month
    else
      @month = Date.today.beginning_of_month
    end
  end

  def monthly_goal_params
    params.require(:monthly_goal).permit(:target_text, :evaluation_text, :review_text)
  end
end
