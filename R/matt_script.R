library(httr)
library(jsonlite)
library(tidyverse)
library(dplyr)
library(tidyr)
library(testthat)

# HELPER FUNCTION

makeApiRequest <- function(url, queryString, api_key) {
  
  # Make the GET request to the specified URL with given query parameters and headers
  response <- VERB("GET", url, query = queryString,
                         add_headers('X-RapidAPI-Key' = api_key,
                                           'X-RapidAPI-Host' = 'api-football-v1.p.rapidapi.com'),
                         content_type("application/octet-stream"))
  
  # Return the response object for further processing
  json_string <- content(response, "text")
  
  # Convert the JSON string to a dataframe
  df <- fromJSON(json_string, flatten = TRUE)
  df_data <- as.data.frame(df$response)

  return(df_data)
}

# TOP SCORER, TOP ASSISTS

getTopScorers <- function(league, season, api_key) {
  
  # Specific url to request
  url <- "https://api-football-v1.p.rapidapi.com/v3/players/topscorers"

  # Hyperparameters
  queryString <- list(
    league = league,
    season = season
  )

  # Call ApiRequest helper function to obtain dataframe
  df_data <- makeApiRequest(url, queryString, api_key)

  # Unnest Statistics column containing goal scorer data
  df_unnested <- df_data %>% unnest(statistics)
  
  # Select relevant columns from dataframe
  df_unnested <- select(df_unnested, player.firstname, player.lastname, player.nationality, games.position, team.name, 
                        league.name, games.appearences, goals.total, goals.assists, shots.total, shots.on)
  
  # Return the unnested data frame
  return(df_unnested)
}

getTopAssists <- function(league, season, api_key) {
  
  # Specific url to request
  url <- "https://api-football-v1.p.rapidapi.com/v3/players/topassists"

  # Hyperparameters
  queryString <- list(
    league = league,
    season = season
  )

  # Call ApiRequest helper function to obtain dataframe
  df_data <- makeApiRequest(url, queryString, api_key)

  # Unnest Statistics column containing goal scorer data
  df_unnested <- df_data %>% unnest(statistics)
  
  # Select relevant columns from dataframe
  df_unnested <- select(df_unnested, player.firstname, player.lastname, player.nationality, games.position, team.name, league.name,
                        games.appearences, goals.assists, goals.total, passes.total, passes.key, passes.accuracy)
  
  # Return the unnested data frame
  return(df_unnested)
}

# FIXTURES

getFootballFixtures <- function(league, season, api_key) {
  
  # Specific url to request
  url <- "https://api-football-v1.p.rapidapi.com/v3/fixtures"
  
  # Hyperparameters
  queryString <- list(
    league = league,
    season = season
  )
  
  # Call ApiRequest helper function to obtain dataframe
  df_data <- makeApiRequest(url, queryString, api_key)

  # Select relevant columns from dataframe
  df_data <- select(df_data, league.name, fixture.venue.name, fixture.date, 
                           fixture.status.long, teams.home.name, teams.away.name, 
                           score.fulltime.home, score.fulltime.away)
  
  return(df_data)
}

# LEAGUE STANDINGS

getFootballStandings <- function(league, season, api_key) {
  
  # Specific url to request
  url <- "https://api-football-v1.p.rapidapi.com/v3/standings"
  
  # Hyperparameters
  queryString <- list(
    league = league,
    season = season
  )
  
  # Call ApiRequest helper function to obtain dataframe
  df_data <- makeApiRequest(url, queryString, api_key)

  # Select relevant columns from dataframe
  df_data <- df_data$league.standings

  # Unlisting twice to obtain df
  inner_list <- df_data[[1]]
  standings_df <- inner_list[[1]]
  
  # Select relevant columns from dataframe
  standings_df <- select(standings_df, rank, team.name, group, description, form, points, all.played,
                         all.win, all.draw, all.lose, all.goals.for, all.goals.against, goalsDiff)

  return(standings_df)
}

# TRANSFERS

getTeamTransfers <- function(team, api_key) {
    
    url <- "https://api-football-v1.p.rapidapi.com/v3/transfers"

    queryString <- list(team = "33")

    df_data <- makeApiRequest(url, queryString, api_key)
    
    expanded_df <- unnest(df_data, cols = transfers)

    expanded_df <- expanded_df %>%
    mutate(date = as.Date(date))

    result_df <- expanded_df %>%
    select(-1) %>%
    arrange(desc(date))

    return(result_df)
}