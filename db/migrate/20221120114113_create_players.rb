class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string  :name,      null: false
      t.string  :server,    null: false
      t.string  :job,       null: false
      t.integer :guild_id
      t.integer :score,     null: false
      t.integer :level,     null: false
      t.integer :talent_id, null: false

      t.timestamps
    end
  end
end
