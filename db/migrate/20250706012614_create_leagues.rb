class CreateLeagues < ActiveRecord::Migration[8.0]
  def change
    create_table :leagues do |t|
      t.string :name
      t.integer :max_users
      t.integer :max_picks_per_user
      t.string :join_code

      t.timestamps
    end
  end
end
