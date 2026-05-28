class CompetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_competition, only: %i[show edit update destroy]
  before_action :check_owner!, only: %i[ edit update destroy ]

  def index
    @competitions = current_user.competitions
  end

  def upcoming
    @competitions = current_user.competitions.upcoming_status
    render :index
  end

  def starting_soon
    @competitions = current_user.competitions.starting_soon
    render :index
  end

  def show; end

  def new
    @competition = Competition.new
  end

  def create
    @competition = current_user.competitions.build(competition_params)
    if @competition.save
      redirect_to @competition, notice: "Competition was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @competition.update(competition_params)
      redirect_to @competition, notice: "Competition was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @competition.destroy
    redirect_to competitions_url, notice: "Competition was successfully destroyed."
  end

  private def check_owner!
    if @competition.user != current_user
      redirect_to competitions_path, alert: "You don\'t have permission for this competition."
    end
  end

  private def set_competition
    @competition = Competition.find(params[:id])
  end

  private def competition_params
    params.require(:competition).permit(
      :title, :start_date, :end_date, :prize_fund, :status, :location_name, :description, sport_ids: [], team_ids: [], tag_ids: []
    )
  end
end
