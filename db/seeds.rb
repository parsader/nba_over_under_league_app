# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Create NBA teams with fake current season data
teams = [
  { name: "Lakers", wins: 12, losses: 8, over_under_line: 50.5 },
  { name: "Warriors", wins: 15, losses: 5, over_under_line: 48.5 },
  { name: "Celtics", wins: 10, losses: 10, over_under_line: 52.5 },
  { name: "Heat", wins: 8, losses: 12, over_under_line: 45.5 },
  { name: "Nuggets", wins: 14, losses: 6, over_under_line: 49.5 },
  { name: "Suns", wins: 11, losses: 9, over_under_line: 47.5 },
  { name: "Knicks", wins: 13, losses: 7, over_under_line: 46.5 },
  { name: "76ers", wins: 9, losses: 11, over_under_line: 48.5 },
  { name: "Bucks", wins: 16, losses: 4, over_under_line: 54.5 },
  { name: "Clippers", wins: 12, losses: 8, over_under_line: 51.5 }
]

teams.each do |team_data|
  Team.find_or_create_by(name: team_data[:name]) do |team|
    team.wins = team_data[:wins]
    team.losses = team_data[:losses]
    team.over_under_line = team_data[:over_under_line]
  end
end

puts "Created #{Team.count} teams"
