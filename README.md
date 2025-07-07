# README



# NBA Over/Under League App

A Ruby on Rails application that allows users to create and participate in NBA over/under prediction leagues.

## NOTE: THIS APP IS STILL UNDER DEVELOPMENT

## Features

### League Management
- **Create Leagues**: Users can create custom leagues with auto-generated join codes
- **Join Leagues**: Players join using 6-character alphanumeric codes
- **League Settings**: Configurable max users (default: 6) and picks per user (default: 10) (TO BE CHANGED)
- **Session-Based Users**: No authentication required - users identified by browser session (TO BE CHANGED)

### Snake Draft System
- **Randomized Draft Order**: When draft starts, user order is randomized
- **Snake Draft Pattern**: Alternating pick order between rounds (Round 1: A→B→C→D, Round 2: D→C→B→A) (UI BUG TO BE FIXED)
- **Turn Enforcement**: Only the current picker can make selections
- **Visual Draft Grid**: Real-time grid showing pick order, current turn, and completed picks

### Pick Management
- **Over/Under Selections**: Pick a team's Over/Under win total, based on Over/Under Lines (Currently fake data for development reasons)
- **Exclusive Picks**: Each team's Over/Under can only be picked once per league
- **Opposite Side Picking**: If Lakers OVER is taken, Lakers UNDER is still available
- **Real-Time Scoring**: Picks scored based on projected season records vs. betting lines

### Scoring & Standings
- **Dynamic Scoring**: Score = distance from line in correct direction
 - Example: Lakers projected 52 wins -> line 50.5 -> OVER pick = +1.5 points, Under pick = -1.5 points
- **Live Leaderboards**: Real-time standings, update as team records change


## Database Models & Relationships

### League
```ruby
# Attributes:
- name: string
- max_users: integer (default: 6)
- max_picks_per_user: integer (default: 10)
- join_code: string (6 chars, unique)
- draft_started: boolean (default: false)
- draft_order: text (JSON array)
- current_pick_position: integer (default: 1)

# Relationships:
- has_many :picks
- has_many :league_users
```

### LeagueUser
```ruby
# Attributes:
- league_id: integer
- user_name: string

# Relationships:
- belongs_to :league
```

### Team
```ruby
# Attributes:
- name: string
- wins: integer
- losses: integer
- over_under_line: decimal

# Relationships:
- has_many :picks

# Methods:
- projected_wins: calculated 82-game projection
```


### Pick
```ruby
# Attributes:
- user_name: string
- league_id: integer
- team_id: integer
- pick_type: string ("over" or "under")

# Relationships:
- belongs_to :team
- belongs_to :league
- belongs_to :league_user

# Methods:
- current_score: calculated performance vs. line
```

## Technology Stack

- **Ruby on Rails:**  8.0.2 
- **Sqlite3:**  2.1  
- **Tailwindcss-ruby:** 4.1
- **tailwindcss-rails:** 4.2
---

## Future Updates
- [ ] Real NBA API integration for live team records
- [ ] Setting max LeagueUser and max Picks per User
- [ ] Google Authorization
- [ ] Devise User Authorization
- [ ] Historical league archives  
- [ ] Draft timer with auto-pick  
- [ ] Trade functionality between users  
- [ ] League commissioner controls
- [ ] League Chat Features

## Bugs To be Fixed
- [ ] Can go over max leagues, create alert
- [ ] Can’t join a full league, create alert
- [ ] Snake order should not restart in grid view
- [ ] Should not be able to join league if draft has started





