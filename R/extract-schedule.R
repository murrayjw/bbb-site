library(rvest)

get_bref_schedule <- function(year = 2021) {
  
  months <- c("december", "january", "february", "march", "april")
  
  schedule <- list()
  
  for(month in months) {
    url <- glue::glue('https://www.basketball-reference.com/leagues/NBA_{year}_games-{month}.html')
    
    tmp <- try(silent = T,
      url %>% 
        read_html() %>% 
        html_table() %>% 
        .[[1]] 
      )
    
    if("try-error" %in% class(tmp)) {
      next
    }
    
    tmp <- janitor::clean_names(tmp)
    
    tmp <- tmp %>% 
      mutate(date = lubridate::mdy(stringr::str_sub(date, 6, -1))) %>% 
      select(date, start_et, visitor = visitor_neutral, 
             home = home_neutral) %>% 
      mutate(playing_teams = paste(visitor, home))
    
    schedule[[month]] <- tmp
    Sys.sleep(3)
  }
  
  schedule <- do.call(rbind, schedule)%>% 
    as_tibble()
  
  return(schedule)
}


schedule2021 <- get_bref_schedule(year = 2021)

save(schedule2021, file = here::here('site_content', 'data', 'schedule2021.Rda'))
