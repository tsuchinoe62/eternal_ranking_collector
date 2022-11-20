class CreateGuilds < ActiveRecord::Migration[7.0]
  def change
    create_table :guilds do |t|
      t.string  :name,         null: false
      t.string  :server,       null: false
      t.string  :master,       null: false
      t.integer :score,        null: false
      t.integer :point,        null: false
      t.integer :member_count, null: false
      t.integer :guild_id,     null: false, unique: true

      t.timestamps
    end
  end
end
