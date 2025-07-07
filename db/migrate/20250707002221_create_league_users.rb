class CreateLeagueUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :league_users do |t|
      t.references :league, null: false, foreign_key: true
      t.string :user_name, null: false

      t.timestamps
    end

    add_index :league_users, [ :league_id, :user_name ], unique: true
  end
end
