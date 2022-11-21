class GuildsController < ApplicationController
  def index
    guilds = Guild.order(score: :desc)
    render json: { status: "SUCCESS", message: "Loaded guilds", data: guilds }
  end
end
