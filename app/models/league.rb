class League < ApplicationRecord
  has_many :picks, dependent: :destroy
  has_many :league_users, dependent: :destroy

  validates :name, presence: true
  validates :max_users, presence: true, numericality: { greater_than: 0 }
  validates :max_picks_per_user, presence: true, numericality: { greater_than: 0 }
  validates :join_code, presence: true, uniqueness: true

  before_validation :generate_join_code, on: :create

  def users
    league_users.pluck(:user_name)
  end

  def user_count
    league_users.count
  end

  def add_user(user_name)
    league_users.find_or_create_by(user_name: user_name)
  end

  # setting up each league's draft order
  def draft_order_array
    return [] unless draft_order.present?
    JSON.parse(draft_order)
  end


  def current_picker
    return nil unless draft_started? && draft_order_array.any?

    total_picks = picks.count
    return nil if total_picks >= (user_count * max_picks_per_user)

    # Calculate which user should pick based on snake draft
    round = (total_picks / user_count) + 1
    position_in_round = total_picks % user_count

    if round.odd?
      # Odd rounds: normal order
      draft_order_array[position_in_round]
    else
      # Even rounds: reverse order (snake)
      draft_order_array[user_count - 1 - position_in_round]
    end
  end

  def can_user_pick?(user_name)
    current_picker == user_name
  end

  def start_draft!
    return false if draft_started? || users.count < 2

    # Randomize the draft order
    randomized_users = users.shuffle
    update!(
      draft_started: true,
      draft_order: randomized_users.to_json,
      current_pick_position: 1
    )
  end

  # setting up the draft grid with the correct order
  def draft_grid_with_order
    return {} unless draft_started?

    grid = {}
    user_list = draft_order_array

    (1..max_picks_per_user).each do |round|
      grid[round] = {}

      user_list.each_with_index do |user_name, index|
        if round.odd?
          # Odd rounds: normal order
          grid[round][index + 1] = user_name
        else
          # Even rounds: reverse order (snake)
          grid[round][user_list.count - index] = user_name
        end
      end
    end

    grid
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
