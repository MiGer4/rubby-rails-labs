class CompetitionsController < ApplicationController
  before_action :set_competition, only: %i[show edit update destroy]

  def index
    @competitions = Competition.all
  end

  def upcoming
    @competitions = Competition.upcoming
    render :index
  end

  def starting_soon
    @competitions = Competition.starting_soon
    render :index
  end

  def show; end

  def new
    @competition = Competition.new
  end

  def create
    @competition = Competition.new(competition_params)
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

  private def set_competition
    @competition = Competition.find(params[:id])
  end

  private def competition_params
    params.require(:competition).permit(
      :title, :start_date, :end_date, :prize_fund, :status, :location_name, :description, sport_ids: [], team_ids: []
    )
  end
end
