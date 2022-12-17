class UpdateServerName < ActiveRecord::Migration[7.0]
  def up
    japan_server =  %w[シラヌイ レンブラント アステル メリッサ ヴァルガー]
    global_server = %w[エヴリン ルーベンス]

    Player.where(server: japan_server).update_all(server: "Japan")
    Player.where(server: global_server).update_all(server: "Global")
    Guild.where(server: japan_server).update_all(server: "Japan")
    Guild.where(server: global_server).update_all(server: "Global")
  end
end
