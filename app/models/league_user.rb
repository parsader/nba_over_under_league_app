class LeagueUser < ApplicationRecord
  belongs_to :league

  validates :user_name, presence: true
  validates :user_name, uniqueness: { scope: :league_id }
end
