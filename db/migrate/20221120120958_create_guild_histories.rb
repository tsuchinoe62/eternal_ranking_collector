class CreateGuildHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :guild_histories do |t|
      t.string  :master,    null: false
      t.integer :score,     null: false
      t.integer :member,    null: false
      t.date    :stored_on, null: false

      t.timestamps
    end

    add_reference :guild_histories, :guild, foreign_key: true
  end
end
