class CreateTalents < ActiveRecord::Migration[7.0]
  def change
    create_table :talents do |t|
      t.string  :name,      null: false, unique: true
      t.integer :talent_id, null: false, unique: true

      t.timestamps
    end
  end
end
