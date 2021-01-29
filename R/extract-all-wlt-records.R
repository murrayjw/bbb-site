
# load libraries ----------------------------------------------------------
library(dplyr)


# load the data -----------------------------------------------------------
load(here::here('site_content', 'data', 'all_matchup_data.Rda'))



# function to calculate the win-loss-tie record each week -----------------
calc_record <- function(t1, t2) {
  wins <- (t1$fgp > t2$fgp) +
    (t1$ftp > t2$ftp) +
    (t1$pts > t2$pts) +
    (t1$assists > t2$assists) +
    (t1$rebounds > t2$rebounds) +
    (t1$blocks > t2$blocks) +
    (t1$steals > t2$steals) +
    (t1$fgm3 > t2$fgm3) +
    (t1$turnovers < t2$turnovers) 
  
  ties <- (t1$fgp == t2$fgp) +
    (t1$ftp == t2$ftp) +
    (t1$pts == t2$pts) +
    (t1$assists == t2$assists) +
    (t1$rebounds == t2$rebounds) +
    (t1$blocks == t2$blocks) +
    (t1$steals == t2$steals) +
    (t1$fgm3 == t2$fgm3) +
    (t1$turnovers ==t2$turnovers)  
  
  losses <- 9 - (wins + ties)
  
  record <- paste(wins, losses, ties, sep = "-")
  
  return(record)
}


# unique teams
teams <- unique(all_matchup_data$team_name)

# unique weeks
weeks <- unique(all_matchup_data$week)

# list to store results
all_results <- list()

# for each week
for(i in weeks) {
  
  week_data <- all_matchup_data %>% 
    filter(week == i)
  
  
  week_results <- list()
  
  # for each team
  for(j in teams) {
    
    team_data <- week_data %>% 
      filter(team_name == j)
    
    other_teams <- setdiff(teams, j)
    
    team_results <- list()
    
    # for each opponent they face
    for(k in other_teams) {
      other_team_data <- week_data %>% 
        filter(team_name == k)
      
      record <- calc_record(team_data, other_team_data)
      
      tmp_res <- tibble(team1 = j, team_2 = k, record = record, week = i)
      
      team_results[[k]] <- tmp_res
      
    }
    team_results <- do.call(rbind, team_results)
    week_results[[j]] <- team_results
    
  }
  week_results <- do.call(rbind, week_results)
  all_results[[i]] <- week_results
}

all_results <- do.call(rbind, all_results)
