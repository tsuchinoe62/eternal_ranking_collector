class RemoveReferenceFromGuildHistories < ActiveRecord::Migration[7.0]
  def change
    remove_reference :guild_histories, :guild, foreign_key: true
    add_column :guild_histories, :guild_id, :integer, null: false
  end
end
