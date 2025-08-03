class MonthlyGoalsController < ApplicationController
  before_action :set_user
  before_action :set_month

  def new
    @monthly_goal = @user.monthly_goals.find_or_initialize_by(month: @month)
  end

  def create
    @monthly_goal = @user.monthly_goals.find_or_initialize_by(month: @month)
    @monthly_goal.assign_attributes(monthly_goal_params)

    if @monthly_goal.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    @monthly_goal = @user.monthly_goals.find_by(month: @month) || @user.monthly_goals.build(month: @month)
  end

  def update
    @monthly_goal = @user.monthly_goals.find(params[:id])
    if @monthly_goal.update(monthly_goal_params)
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
    if params[:year].present? && params[:month].present?
      @month = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      @month = Date.today.beginning_of_month
    end
  end

  def monthly_goal_params
    params.require(:monthly_goal).permit(:target_text, :evaluation_text, :review_text)
  end
end
