class LeaguesController < ApplicationController
  before_action :ensure_user_name
  def index
    @leagues = League.all.order(:created_at)
    @current_league = League.find(session[:current_league_id]) if session[:current_league_id]
  end

  def show
    # @league = League.find(params[:id])
    # @teams = @league.available_teams.order(:name)
    # @user_picks = @league.picks.where(user_name: session[:user_name]).includes(:team)
    # @standings = @league.standings

    # session[:current_league_id] = @league.id
    @league = League.find(params[:id])
    @all_teams = Team.all.order(:name)
    @user_picks = @league.picks.where(user_name: session[:user_name]).includes(:team)
    @league_picks = @league.picks.includes(:team) # All picks in league
    @standings = @league.standings
    @draft_grid = @league.draft_grid_with_order

    session[:current_league_id] = @league.id
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    @league.max_users = 6
    @league.max_picks_per_user = 10

    if @league.save
      session[:current_league_id] = @league.id
      @league.add_user(session[:user_name])
      redirect_to @league, notice: "League '#{@league.name}' created! Join code: #{@league.join_code}"
    else
      render :new
    end
  end

  def join_by_code
    join_code = params[:join_code]&.upcase&.strip
    @league = League.find_by(join_code: join_code)

    if @league
      # Check if user is already in league
      if @league.users.include?(session[:user_name])
        session[:current_league_id] = @league.id
        redirect_to @league, notice: "Welcome back to '#{@league.name}'!"
        return
      end

      if @league.user_count < @league.max_users
        session[:current_league_id] = @league.id
        # Add user to league
        @league.add_user(session[:user_name])
        redirect_to @league, notice: "Joined '#{@league.name}'! You are #{session[:user_name]}"
      else
        redirect_to leagues_path, alert: "League '#{@league.name}' is full (#{@league.max_users} users max)!"
      end
    else
      redirect_to leagues_path, alert: "Invalid join code: '#{join_code}'"
    end
  end

  def start_draft
    @league = League.find(params[:id])

    if @league.start_draft!
      redirect_to @league, notice: "Draft started! #{@league.current_picker} has the first pick."
    else
      redirect_to @league, alert: "Cannot start draft. Need at least 2 users and draft not already started."
    end
  end


  def pick_over
    make_pick("over")
  end


  def pick_under
    make_pick("under")
  end






  private

  def league_params
    params.require(:league).permit(:name)
  end

  def ensure_user_name
    session[:user_name] ||= "User#{SecureRandom.alphanumeric(4)}"
  end

  def make_pick(pick_type)
    @league = League.find(params[:league_id])
    @team = Team.find(params[:team_id])

    # Check if draft has started
    unless @league.draft_started?
      redirect_to @league, alert: "Draft hasn't started yet!"
      return
    end

    # Check if it's this user's turn
    unless @league.can_user_pick?(session[:user_name])
      current_picker = @league.current_picker
      redirect_to @league, alert: "It's #{current_picker}'s turn to pick!"
      return
    end

    # # Check if team already picked in this league
    # if @league.picks.exists?(team_id: @team.id)
    #   redirect_to @league, alert: "#{@team.name} already picked by someone else!"
    #   return
    # end
    # Check if THIS SPECIFIC pick type already exists (not just any pick for this team)
    existing_pick = @league.picks.find_by(team_id: @team.id, pick_type: pick_type)
    if existing_pick
      redirect_to @league, alert: "#{@team.name} #{pick_type.upcase} already picked by #{existing_pick.user_name}!"
      return
    end

    # Check if user has reached max picks
    user_pick_count = @league.picks.where(user_name: session[:user_name]).count
    if user_pick_count >= @league.max_picks_per_user
      redirect_to @league, alert: "You've reached the maximum #{@league.max_picks_per_user} picks!"
      return
    end

    # Create the pick
    @league.picks.create!(
      user_name: session[:user_name],
      team: @team,
      pick_type: pick_type
    )

    # Update the league's current pick position
    next_picker = @league.current_picker
    if next_picker
      redirect_to @league, notice: "#{session[:user_name]} picked #{@team.name} #{pick_type.upcase}! #{next_picker}'s turn."
    else
      redirect_to @league, notice: "#{session[:user_name]} picked #{@team.name} #{pick_type.upcase}! Draft complete!"
    end
  end
end
