library(httr)
library(jsonlite)
library(tidyverse)
library(dplyr)
library(tidyr)
library(testthat)

#' Make API Request
#'
#' This helper function sends a GET request to a specified URL with given query parameters and headers,
#' then processes the response into a dataframe.
#'
#' @param url The API endpoint URL.
#' @param queryString A list of query parameters for the API request.
#' @param api_key The API key for authenticating the request to RAPID-API.
#' @return A dataframe with the response data.
#' @examples
#' \dontrun{
#' makeApiRequest("https://api-football-v1.p.rapidapi.com/v3/leagues", list(country="England"), "your_api_key")
#' }
#' @export
#' @importFrom httr VERB content_type add_headers content
#' @importFrom jsonlite fromJSON
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

#' Get Top Scorers
#'
#' Retrieves the top scorers from a specified league and season.
#'
#' @param league The league ID for which to retrieve top scorers.
#' @param season The season for which to retrieve top scorers.
#' @param api_key The API key for RAPID-API access.
#' @return A dataframe listing top scorers including player name, nationality, position, and statistics.
#' @examples
#' \dontrun{
#' getTopScorers(39, 2020, "your_api_key")
#' }
#' @export
#' @importFrom dplyr select unnest
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
                        league.name, games.appearances, goals.total, goals.assists, shots.total, shots.on)

  # Return the unnested data frame
  return(df_unnested)
}

#' Get Top Assists
#'
#' Retrieves the top assist providers from a specified league and season.
#'
#' @param league The league ID for which to retrieve top assists.
#' @param season The season for which to retrieve top assists.
#' @param api_key The API key for RAPID-API access.
#' @return A dataframe listing top assist providers including player name, nationality, position, and statistics.
#' @examples
#' \dontrun{
#' getTopAssists(39, 2020, "your_api_key")
#' }
#' @export
#' @importFrom dplyr select unnest
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
                        games.appearances, goals.assists, goals.total, passes.total, passes.key, passes.accuracy)

  # Return the unnested data frame
  return(df_unnested)
}


#' Get Football Fixtures
#'
#' Retrieves football fixtures for a specified league and season.
#'
#' @param league The league ID for which to retrieve fixtures.
#' @param season The season for which to retrieve fixtures.
#' @param api_key The API key for RAPID-API access.
#' @return A dataframe of football fixtures including dates, teams, and scores.
#' @examples
#' \dontrun{
#' getFootballFixtures(39, 2020, "your_api_key")
#' }
#' @export
#' @importFrom dplyr select
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

  #Select relevant columns from dataframe
  df_data <- select(df_data, league.name, fixture.venue.name, fixture.date,
                           fixture.status.long, teams.home.name, teams.away.name,
                           score.fulltime.home, score.fulltime.away)

  return(df_data)
}

# LEAGUE STANDINGS
#' Get Football Standings
#'
#' Retrieves the standings for a specified league and season.
#'
#' @param league The league ID for which to retrieve standings.
#' @param season The season for which to retrieve standings.
#' @param api_key The API key for RAPID-API access.
#' @return A dataframe of league standings including team names, ranks, and points.
#' @examples
#' \dontrun{
#' getFootballStandings(39, 2020, "your_api_key")
#' }
#' @export
#' @importFrom dplyr select
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

#' Get Team Transfers
#'
#' Retrieves transfer information for a specified team.
#'
#' @param team The team ID for which to retrieve transfer information.
#' @param api_key The API key for RAPID-API access.
#' @return A dataframe of team transfers including player names, transfer dates, and transfer details.
#' @examples
#' \dontrun{
#' getTeamTransfers(33, "your_api_key")
#' }
#' @export
#' @importFrom dplyr select mutate arrange unnest
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
