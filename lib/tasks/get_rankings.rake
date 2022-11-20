# rubocop:disable Metrics/BlockLength

require "net/https"
require "uri"
require "json"

def logger
  Rails.logger
end

namespace :get_rankings do
  desc "get ranking"

  def get_json(uri)
    uri = URI.parse(uri)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(req)

    if res.code != "200"
      p res.code, res.msg
      p res.body
      return nil
    end

    JSON.parse(res.body)
  end

  Rails.logger = Logger.new(STDOUT)

  task players: :environment do
    logger.info "Start collecting player cp data."

    Talent.pluck(:talent_id).each do |i|
      logger.debug "Start HTTP request."
      data = get_json("https://app.p-eternal.jp/api/game/get/ranking/?world_id=-1&col=talent&sub=#{i}&limit=300&offset=0")

      raise RuntimeError "Could not get response from API server." unless data

      data["res"].each do |u|
        player = Player.find_by(server: u["server"], name: u["name"])

        if player.nil?
          player = Player.create!(server: u["server"], name: u["name"], job: u["job"], guild_id: u["guild_id"],
                                  score: u["score"], level: u["level"], talent_id: u["talent_id"])
          logger.info "Created player #{player.attributes.inspect}"
        else
          player.update!(guild_id: u["guild_id"], score: u["score"], level: u["level"], talent_id: u["talent_id"])
          logger.info "Updated player #{player.attributes.inspect}"
        end

        player_history = PlayerHistory.find_by(player_id: player.id, stored_on: Date.today)
        if player_history.nil?
          player_history ||= PlayerHistory.create!(player_id: player.id, guild_id: u["guild_id"], score: u["score"],
                                                   level: u["level"], talent_id: u["talent_id"], stored_on: Date.today)
          logger.info "Created player history #{player_history.attributes.inspect}"
        end
      end
    end
  end

  task guilds: :environment do
    logger.info "Start collecting guild cp data."

    logger.debug "Start HTTP request."
    data = get_json("https://app.p-eternal.jp/api/game/get/ranking/?world_id=-1&col=guild&sub=0&limit=300&offset=0")

    raise RuntimeError "Could not get response from API server." unless data

    data["res"].each do |g|
      guild = Guild.find_by(guild_id: g["guild_id"])

      if guild.nil?
        guild = Guild.create!(guild_id: g["guild_id"], name: g["guild"], server: g["server"], master: g["name"],
                              score: g["score"], member_count: 0, point: 0)
        logger.info "Created guild #{guild.attributes.inspect}"
      else
        guild.update!(master: g["name"], score: g["score"])
        logger.info "Updated guild #{guild.attributes.inspect}"
      end
    end

    logger.info "Start collecting guild point data."
    data = get_json("https://app.p-eternal.jp/api/game/get/ranking/?world_id=-1&col=guild&sub=1&limit=300&offset=0")

    data["res"].each do |g|
      guild = Guild.find_by(guild_id: g["guild_id"])

      if guild.nil?
        guild = Guild.create!(guild_id: g["guild_id"], name: g["guild"], server: g["server"],
                              master: g["name"], score: 0, member_count: 0, point: g["score"])
        logger.info "Created guild #{guild.attributes.inspect}"
      else
        guild.update!(master: g["name"], point: g["score"])
        logger.info "Updated guild #{guild.attributes.inspect}"
      end
    end

    logger.info "Start updating guild member count."
    Guild.all.each do |g|
      g.update!(member_count: Player.where(guild_id: g.guild_id).size)
    end
  end
end