class GuildsController < ApplicationController
  def index
    guilds = params[:server].present? ? Guild.where(server: params[:server]) : Guild.all
    guilds = guilds.where("name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    guilds = guilds.where("master LIKE ?", "%#{params[:master]}%") if params[:master].present?
    guilds = guilds.where("member_count >= ?", params[:member_min].to_i) if params[:member_min].present?
    guilds = guilds.where("member_count <= ?", params[:member_max].to_i) if params[:member_max].present?
    guilds = guilds.order(score: :desc)

    render json: { status: "SUCCESS", message: "Loaded guilds", data: guilds }
  end

  def show
    guild = Guild.find(params[:id])
    guild_histories = GuildHistory.where(guild_id: guild.id)
    render json: { status: "SUCCESS", message: "Loaded guild", data: { detail: guild, histories: guild_histories } }
  end
end
