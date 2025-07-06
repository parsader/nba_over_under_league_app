class League < ApplicationRecord
  has_many :picks, dependent: :destroy

  validates :name, presence: true
  validates :max_users, presence: true, numericality: { greater_than: 0 }
  validates :max_picks_per_user, presence: true, numericality: { greater_than: 0 }
  validates :join_code, presence: true, uniqueness: true

  before_validation :generate_join_code, on: :create

  def users
    picks.select(:user_name).distinct.pluck(:user_name)
  end

  def user_count
    users.count
  end

  def standings
    picks.includes(:team).group_by(&:user_name).map do |user_name, user_picks|
      total_score = user_picks.sum(&:current_score)
      { user_name: user_name, total_score: total_score, pick_count: user_picks.count }
    end.sort_by { |user| -user[:total_score] }
  end

  def available_teams
    picked_team_ids = picks.pluck(:team_id)
    Team.where.not(id: picked_team_ids)
  end


  private

  def generate_join_code
    self.join_code = SecureRandom.alphanumeric(6).upcase
  end
end
