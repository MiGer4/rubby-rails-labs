class CompetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_competition, only: %i[show edit update destroy]
  before_action :check_owner!, only: %i[ edit update destroy ]

  def index
    @my_competitions = current_user.competitions
    @shared_competitions = current_user.shared_competitions
  end

  def upcoming
    @my_competitions = current_user.competitions.upcoming_status
    @shared_competitions = current_user.shared_competitions.upcoming_status
    render :index
  end

  def starting_soon
    @my_competitions = current_user.competitions.starting_soon
    @shared_competitions = current_user.shared_competitions.starting_soon
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

  def add_collaborator
    @competition = Competition.find(params[:id])
    if @competition.user != current_user
      redirect_to @competition, alert: "Only the owner can add collaborators."
      return
    end

    collaborator = User.find_by(email: params[:email])

    if collaborator
      if collaborator == current_user
        redirect_to @competition, alert: "You are already the owner!"
      elsif @competition.collaborators.include?(collaborator)
        redirect_to @competition, alert: "User is already a collaborator."
      else
        @competition.collaborators << collaborator
        redirect_to @competition, notice: "#{collaborator.email} was successfully added as a collaborator!"
      end
    else
      redirect_to @competition, alert: "User with this email not found."
    end
  end

  def remove_collaborator
    @competition = Competition.find(params[:id])
    if @competition.user != current_user
      redirect_to @competition, alert: "Only the owner can remove collaborators"
      return
    end

    collaborator = User.find(params[:collaborator_id])
    if @competition.collaborators.delete(collaborator)
      redirect_to @competition, notice: "#{collaborator.email} was successfully removed."
    else
      redirect_to @competition, alert: "Failed to remove collaborator."
    end
  end

  private def check_owner!
    unless @competition.user == current_user || @competition.collaborators.include?(current_user)
      redirect_to competitions_path, alert: "You don't have permission for this competition."
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
