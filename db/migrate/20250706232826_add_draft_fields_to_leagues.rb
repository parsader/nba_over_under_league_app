class AddDraftFieldsToLeagues < ActiveRecord::Migration[8.0]
  def change
    add_column :leagues, :draft_started, :boolean, default: false
    add_column :leagues, :draft_order, :text
    add_column :leagues, :current_pick_position, :integer, default: 1
  end
end
