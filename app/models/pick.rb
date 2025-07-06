class Pick < ApplicationRecord
  belongs_to :team
  belongs_to :league, class_name: "League", foreign_key: "league_id"

  validates :user_name, presence: true
  validates :pick_type, inclusion: { in: %w[over under] }
  validates :team_id, uniqueness: { scope: [ :league_id, :pick_type ] }

  def current_score
    projected = team.projected_wins
    line = team.over_under_line

    if pick_type == "over"
      (projected - line).round(1)
    else
      (line - projected).round(1)
    end
  end
end
