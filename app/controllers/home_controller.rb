class HomeController < ApplicationController
  def index
    @teams = Team.all.order(:name)
    @picks = session[:picks] || {}
    @current_league = League.find(session[:current_league_id]) if session[:current_league_id]
  end

  def pick_over
    team = Team.find(params[:team_id])
    session[:picks] ||= {}

    # Add the over pick to session
    session[:picks][team.id.to_s] = {
      "team_name" => team.name,
      "pick_type" => "over",
      "over_under_line" => team.over_under_line.to_f,
      "projected_wins" => team.projected_wins.to_f,
      "current_score" => (team.projected_wins - team.over_under_line).to_f
    }

    redirect_to root_path
  end

  def pick_under
    team = Team.find(params[:team_id])
    session[:picks] ||= {}

    # Add the under pick to session
    session[:picks][team.id.to_s] = {
      "team_name" => team.name,
      "pick_type" => "under",
      "over_under_line" => team.over_under_line.to_f,
      "projected_wins" => team.projected_wins.to_f,
      "current_score" => (team.over_under_line - team.projected_wins).to_f
    }

    redirect_to root_path
  end

  def reset_picks
  session[:picks] = {}
  redirect_to root_path
  end

  def reset_session
    session[:picks] = {}
    session[:user_name] = nil
    session[:current_league_id] = nil
    redirect_to root_path, notice: "Session completely cleared! You are now a new user."
  end

  def reset_all_data
    # Clear all database data
    Pick.destroy_all
    League.destroy_all

    # Clear session
    session[:picks] = {}
    session[:user_name] = nil
    session[:current_league_id] = nil

    redirect_to root_path, notice: "All leagues and picks deleted! Fresh start!"
  end
end
