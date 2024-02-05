
# Load libraries
library(httr)
library(tidyverse)
library(ggplot2)
library(jsonlite)
library(dplyr)
library(gt)
library(roxygen2)


# Get league Id by name
getLeagueId <- function(league_name, apikey) {
  url <- "https://v3.football.api-sports.io/leagues"
  headers <- c(
    'x-rapidapi-host' = 'v3.football.api-sports.io',
    'x-rapidapi-key' = apikey
  )
  
  # Make the GET request
  response <- GET(url, add_headers(.headers=headers))
  raw_data <- content(response, "text", encoding = 'UTF-8')
  jsonData <- fromJSON(raw_data)
  response_data <- jsonData$response
  
  # Initialize an empty list for storage
  league_list <- list()
  
  # Populate the list in the loop
  for (i in seq_along(response_data)) {
    league_id <- response_data[[i]]$league$id
    country_name <- response_data[[i]]$country$name
    
    # Create a temporary dataframe for the current league
    temp_df <- data.frame(id = league_id, country = country_name, stringsAsFactors = FALSE)
    
    # If the league name already exists, bind the rows to the existing dataframe
    if (!is.null(league_list[[response_data[[i]]$league$name]])) {
      league_list[[response_data[[i]]$league$name]] <- rbind(league_list[[response_data[[i]]$league$name]], temp_df)
    } else {
      # Otherwise, create a new entry with the league name as the key
      league_list[[response_data[[i]]$league$name]] <- temp_df
    }
  }
  
  # Return the dataframe for the specified league name, or NULL if not found
  if (!is.null(league_list[[league_name]])) {
    return(league_list[[league_name]])
  } else {
    return(NULL)
  }
}

# Example Usage
getLeagueId("Premier League", "c2fc2c53bc1c1a2a3b15124124996cbd")
getLeagueId("World Cup", "c2fc2c53bc1c1a2a3b15124124996cbd")




# Helper function: get team id by name
getTeamId <- function(team, apikey) {
  
  # Construct the URL with query parameters
  url <- paste0("https://v3.football.api-sports.io/teams?",
                "name=", tolower(gsub(" ", "+", team, fixed = TRUE)))
  
  # Set the headers
  headers <- c(
    'x-rapidapi-host' = 'v3.football.api-sports.io',
    'x-rapidapi-key' = apikey
  )
  
  # Make the GET request
  response <- GET(url, add_headers(.headers=headers))
  
  # Check if the request was successful
  if (status_code(response) == 200) {
    # Parse the response body from JSON
    raw_data <- content(response, "text", encoding = 'UTF-8')
    jsonData <- fromJSON(raw_data)
    team_id <- jsonData$response[[1]]$team$id
    
    return(team_id)
  } else {
    stop("Request failed with status code ", status_code(response))
  }
}
# Example Usage
getTeamId('Manchester United', 'c2fc2c53bc1c1a2a3b15124124996cbd')
getTeamId("Paris Saint Germain", 'c2fc2c53bc1c1a2a3b15124124996cbd')



#' Retrieve Team Statistics
#'
#' Fetches and returns team statistics as a data frame for specified league, season, and team.
#'
#' @param league The league's ID.
#' @param season The season year.
#' @param team The team's name.
#' @param apikey Your API key for API-Sports.io.
#' 
#' @return Data frame with statistics: Played, Wins, Draws, Loses, Goals For/Against, and Averages.
#' 
#' @examples
#' getTeamStatistics(39, 2019, "Manchester United", "<your_api_key>")
#' 
#' @export
getTeamStatistics <- function(league, season, team, apikey) {
  
  # Get team id by team name
  team_id <- getTeamId(team, apikey)
  
  # Construct the URL with query parameters
  url <- paste0("https://v3.football.api-sports.io/teams/statistics?",
                "league=", league,
                "&season=", season,
                "&team=", team_id)
  
  # Set the headers
  headers <- c(
    'x-rapidapi-host' = 'v3.football.api-sports.io',
    'x-rapidapi-key' = apikey
  )
  
  # Make the GET request
  response <- GET(url, add_headers(.headers=headers))
  
  # Check if the request was successful
  if (status_code(response) == 200) {
    # Parse the response body from JSON
    raw_data <- content(response, "text", encoding = 'UTF-8')
    jsonData <- fromJSON(raw_data)
    stats <- jsonData$response
    
    # Constructing the data frame with fixtures and goals
    df <- data.frame(
      Category = c("Played", "Wins", "Draws", "Loses", "Goals For", "Goals Against", "Goals For Avg", "Goals Against Avg"),
      Home = c(
        stats$fixtures$played$home, 
        stats$fixtures$wins$home, 
        stats$fixtures$draws$home, 
        stats$fixtures$loses$home, 
        stats$goals$`for`$total$home, 
        stats$goals$against$total$home,
        stats$goals$`for`$average$home,
        stats$goals$against$average$home
      ),
      Away = c(
        stats$fixtures$played$away, 
        stats$fixtures$wins$away, 
        stats$fixtures$draws$away, 
        stats$fixtures$loses$away,
        stats$goals$`for`$total$away,
        stats$goals$against$total$away,
        stats$goals$`for`$average$away,
        stats$goals$against$average$away
      ),
      Total = c(
        stats$fixtures$played$total, 
        stats$fixtures$wins$total, 
        stats$fixtures$draws$total, 
        stats$fixtures$loses$total,
        stats$goals$`for`$total$total,
        stats$goals$against$total$total,
        stats$goals$`for`$average$total,
        stats$goals$against$average$total
      )
    )
    
    # Extract title content
    team_name <- stats$team$name
    league_name <- stats$league$name
    league_season <- stats$league$season
    
    # Create gt table to get a prettier output
    gt_table <- df %>%
      gt() %>%
      tab_header(
        title = team_name,
        subtitle = paste(league_name, league_season)
      )
    
    return(gt_table)
  } else {
    stop("Request failed with status code ", status_code(response))
  }
}

# Example Usage
getTeamStatistics(39, 2019, "Manchester United", 'c2fc2c53bc1c1a2a3b15124124996cbd')




#' Search Player Information
#'
#' Searches for information about a player by name and team using the API-Sports API.
#' It retrieves the player's detailed information and displays it in a `gt` table format.
#'
#' @param name The name of the player to search for.
#' @param team The name of the team the player is associated with.
#' @param apikey Your API key for accessing the API-Sports API.
#'
#' @return A `gt` table containing detailed information about the player.
#'         If the request fails, the function stops with an error message.
#' @export
#'
#' @examples
#'   searchPlayer(name = "Ronaldo", team = "Juventus", apikey = "your_api_key_here")
searchPlayer <- function(name, team, apikey) {
  
  # Get team id by name
  team_id <- getTeamId(team, apikey)
  # Construct the URL with query parameters
  url <- paste0("https://v3.football.api-sports.io/players?",
                "team=", team_id,
                "&search=", tolower(name))
  
  # Set the headers
  headers <- c(
    'x-rapidapi-host' = 'v3.football.api-sports.io',
    'x-rapidapi-key' = apikey
  )
  
  # Make the GET request
  response <- GET(url, add_headers(.headers=headers))
  
  # Check if the request was successful
  if (status_code(response) == 200) {
    # Parse the response body from JSON
    raw_data <- content(response, "text", encoding = 'UTF-8')
    jsonData <- fromJSON(raw_data)
    
    # Convert response to data frame
    player_info <- data.frame(jsonData$response[[1]]$player)
    player_info <- t(player_info)
    df <- as.data.frame(player_info, stringsAsFactors = FALSE)
    
    # Creating the gt table to make the output prettier
    gt_table <- df %>%
      gt(rownames_to_stub = T) %>%
      tab_header(
        title = name,
        subtitle = team
      ) %>%
      tab_options(
        column_labels.hidden = TRUE
      )
    
    return(gt_table)
  } else {
    stop("Request failed with status code ", status_code(response))
  }
}

searchPlayer("Neymar", "Paris Saint Germain", 'c2fc2c53bc1c1a2a3b15124124996cbd')



#' Retrieve Player Statistics
#'
#' Fetches and displays player statistics for a specified player ID and season
#' using the API-Sports.io API. The result is presented in a `gt` table format,
#' including various statistics like appearances, goals, assists, and more.
#'
#' @param id The unique identifier for the player.
#' @param season The season year to fetch statistics for.
#' @param apikey Your API key for accessing the API-Sports.io.
#'
#' @return A `gt` table containing the player's statistics for the specified season.
#'         If the request fails, the function stops with an error message.
#' @export
#'
#' @examples
#'   getPlayerStatistics(276, 2019, 'your_api_key_here')
#'   
getPlayerStatistics <- function(id, season, apikey) {
  
  # Construct the URL with query parameters
  url <- paste0("https://v3.football.api-sports.io/players?",
                "id=", id,
                "&season=", season
                )
  
  # Set the headers
  headers <- c(
    'x-rapidapi-host' = 'v3.football.api-sports.io',
    'x-rapidapi-key' = apikey
  )
  
  # Make the GET request
  response <- GET(url, add_headers(.headers=headers))
  
  # Check if the request was successful
  if (status_code(response) == 200) {
    # Parse the response body from JSON
    jsonData <- fromJSON(content(response, "text", encoding = 'UTF-8'))
    stats <- jsonData$response[[1]]$statistics
    
    statistics_list <- list()
    # Loop through each item in the `stats` list
    for (i in 1:length(stats)) {
      statistics <- stats[[i]]
      
      # Create a tibble for the current set of statistics
      statistics_tbl <- tibble(
        team_name = statistics$team$name,
        league_name = statistics$league$name,
        appearances = statistics$games$appearences,
        lineups = statistics$games$lineups,
        minutes = statistics$games$minutes,
        goals_total = statistics$goals$total,
        assists = statistics$goals$assists,
        shots_total = statistics$shots$total,
        shots_on = statistics$shots$on,
        passes_total = statistics$passes$total,
        tackles_total = statistics$tackles$total,
        dribbles_attempts = statistics$dribbles$attempts,
        dribbles_success = statistics$dribbles$success,
        fouls_drawn = statistics$fouls$drawn,
        fouls_committed = statistics$fouls$committed,
        cards_yellow = statistics$cards$yellow,
        cards_red = statistics$cards$red,
        penalty_scored = statistics$penalty$scored,
        penalty_missed = statistics$penalty$missed
        # Add more fields as needed
      )
      
      # Append the current tibble to the list
      statistics_list[[i]] <- statistics_tbl
    }
    
    # Combine all tibbles in the list into one dataframe
    df <- t(bind_rows(statistics_list))
    df <- as.data.frame(df, stringsAsFactors = FALSE)
    
    # Creating the gt table to make the output prettier
    player_name <- paste(jsonData$response[[1]]$player$firstname,
                         jsonData$response[[1]]$player$lastname)
    gt_table <- df %>%
      gt(rownames_to_stub = T) %>%
      tab_header(
        title = player_name,
        subtitle = paste("Season", season)
      ) %>%
      tab_options(
        column_labels.hidden = TRUE
      )
    
    return(gt_table)
  } else {
    stop("Request failed with status code ", status_code(response))
  }
}

# Example Usage
getPlayerStatistics(276, 2019, 'c2fc2c53bc1c1a2a3b15124124996cbd')



# test
url <- "https://v3.football.api-sports.io/players?team=85&search=neymar"
headers <- c(
  'x-rapidapi-host' = 'v3.football.api-sports.io',
  'x-rapidapi-key' = 'c2fc2c53bc1c1a2a3b15124124996cbd'
)
response <- GET(url, add_headers(.headers=headers))
raw_data <- content(response, "text", encoding = 'UTF-8')
jsonData <- fromJSON(raw_data)
response <- jsonData$response