class CreatePlayerHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :player_histories do |t|
      t.integer :guild_id
      t.integer :score,     null: false
      t.integer :level,     null: false
      t.integer :talent_id, null: false
      t.date    :stored_on, null: false

      t.timestamps
    end

    add_reference :player_histories, :player, foreign_key: true
  end
end
