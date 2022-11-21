class PlayersController < ApplicationController
  def index
    players = Player.order(score: :desc)
    render json: { status: "SUCCESS", message: "Loaded players", data: players }
  end
end
