library(YahooFantasyAPI)
library(fantasyHelp)
library(dplyr)
library(purrr)
library(tidyr)

get_api_token()



# get the standings -------------------------------------------------------

standings <- get_standings()

save(standings, file = here::here('site_content', 'data', 'standings.Rda'))


# get team stats ----------------------------------------------------------


team_stats <- get_team_stats()
save(team_stats, file = here::here('site_content', 'data', 'team_stats.Rda'))


# get roster stats --------------------------------------------------------

team_ids <- 1:14

rosters <- lapply(team_ids, function(x) {
  get_roster_players(team_id = x)
})

all_rosters <- do.call(rbind, rosters)

# save list
save(rosters, file = here::here('site_content', 'data', 'rosters.Rda'))
# save binded list data
save(all_rosters, file = here::here('site_content', 'data', 'all_rosters.Rda'))


# get player_stats --------------------------------------------------------

player_keys <- unique(all_rosters$player_key)


player_stats <- lapply(player_keys, function(x) {
  get_player_stats(player_key = x)
})


all_player_stats <- do.call(rbind, player_stats)

# save list
save(player_stats, file = here::here('site_content', 'data', 'player_stats.Rda'))
# save binded list data
save(all_player_stats, file = here::here('site_content', 'data', 'all_player_stats.Rda'))


# get match-up stats each week ---------------------------------------------

current_week <- get_current_week()

weeks <- 1:current_week

matchup_data <- list()
for(i in weeks) {
  
  matchup_data[[i]] <- get_matchup_results(week = i)
  
}

all_matchup_data <- do.call(rbind, matchup_data)

# save list
save(matchup_data, file = here::here('site_content', 'data', 'matchup_data.Rda'))
# save binded list data
save(all_matchup_data, file = here::here('site_content', 'data', 'all_matchup_data.Rda'))


team_ids <- standings %>% 
  select(team_id, manager, name, url, team_logos)


save(team_ids, file = here::here('site_content', 'data', 'team_ids.Rda'))



# get available players ---------------------------------------------------

available_players <- get_available_players()
# save list
save(available_players, file = here::here('site_content', 'data', 'available_players.Rda'))