class Team < ApplicationRecord
  validates :name, presence: true
  validates :over_under_line, presence: true

  def projected_wins
    return 0 if wins.nil? || losses.nil? || (wins + losses) == 0
    ((wins.to_f / (wins + losses)) * 82).round(1)
  end
end
