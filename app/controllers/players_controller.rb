class PlayersController < ApplicationController
  def index
    players = params[:server].present? ? Player.where(server: params[:server]) : Player.all
    players = players.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    players = players.where(job: params[:job]) if params[:job].present?
    players = players.where("level >= ?", params[:level_min].to_i) if params[:level_min].present?
    players = players.where("level <= ?", params[:level_max].to_i) if params[:level_max].present?
    players = players.where("score >= ?", params[:score_min].to_i) if params[:score_min].present?
    players = players.where("score <= ?", params[:score_max].to_i) if params[:score_max].present?
    players = players.order(score: :desc)

    render json: { status: "SUCCESS", message: "Loaded players", data: players }
  end

  def show
    player = Player.find(params[:id])
    player_histories = player.player_histories
    render json: { status: "SUCCESS", message: "Loaded player", data: { detail: player, histories: player_histories } }
  end
end
