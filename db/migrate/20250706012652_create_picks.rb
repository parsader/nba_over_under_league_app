class CreatePicks < ActiveRecord::Migration[8.0]
  def change
    create_table :picks do |t|
      t.string :user_name
      t.integer :league_id
      t.references :team, null: false, foreign_key: true
      t.string :pick_type

      t.timestamps
    end
  end
end
