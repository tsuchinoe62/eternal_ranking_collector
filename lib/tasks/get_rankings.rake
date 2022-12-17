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
      data = get_json("https://app.p-eternal.jp/api/game/get/ranking/?world_id=7&col=talent&sub=#{i}&limit=100&offset=0")

      raise RuntimeError "Could not get response from API server." unless data

      data["res"].each do |u|
        player = Player.find_by(server: u["server"], name: u["name"])

        if player.nil?
          player = Player.create!(server: u["server"], name: u["name"], job: u["job"], guild_id: u["guild_id"],
                                  score: u["score"], level: u["level"], talent_id: i)
          logger.info "Created player #{player.attributes.inspect}"
        else
          player.update!(guild_id: u["guild_id"], score: u["score"], level: u["level"], talent_id: i)
          logger.info "Updated player #{player.attributes.inspect}"
        end

        today = DateTime.now.in_time_zone("Asia/Tokyo").to_date
        player_history = PlayerHistory.find_by(player_id: player.id, stored_on: today)
        if player_history.nil?
          player_history = PlayerHistory.create!(player_id: player.id, guild_id: u["guild_id"], score: u["score"],
                                                   level: u["level"], talent_id: i, stored_on: today)
          logger.info "Created player history #{player_history.attributes.inspect}"
        end
      end
    end

    logger.info "Finished collecting player cp data."
  end

  task guilds: :environment do
    logger.info "Start collecting guild cp data."

    logger.debug "Start HTTP request."
    data = get_json("https://app.p-eternal.jp/api/game/get/ranking/?world_id=7&col=guild&sub=0&limit=100&offset=0")

    raise RuntimeError "Could not get response from API server." unless data

    today = DateTime.now.in_time_zone("Asia/Tokyo").to_date
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

      guild_history = GuildHistory.find_by(guild_id: guild.guild_id, stored_on: today)
      if guild_history.nil?
        guild_history = GuildHistory.create!(guild_id: guild.guild_id, master: g["name"], score: g["score"], member: 0, stored_on: today)
        logger.info "Created guild history #{guild_history.attributes.inspect}"
      end
    end
    logger.info "Finished collecting guild cp data."

    logger.info "Start collecting guild point data."
    data = get_json("https://app.p-eternal.jp/api/game/get/ranking/?world_id=7&col=guild&sub=1&limit=100&offset=0")

    raise RuntimeError "Could not get response from API server." unless data

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
    logger.info "Finished collecting guild score data."

    logger.info "Start updating guild member count."
    Guild.all.each do |g|
      member_count = Player.where(guild_id: g.guild_id).size
      g.update!(member_count: member_count)
      GuildHistory.find_by(guild_id: g.guild_id, stored_on: today)&.update!(member: member_count)
      logger.info "Updated guild #{g.attributes.inspect}"
    end
    logger.info "Finished updating guild member count."
  end
end
