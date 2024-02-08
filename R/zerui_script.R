
# Load libraries
library(httr)
library(tidyverse)
library(jsonlite)
library(dplyr)
library(gt)


#' Retrieve League Information by Name
#'
#' This function queries the API Sports Football API to retrieve information
#' about a football league by its given name. It constructs a query, sends a
#' GET request to the API, and returns a dataframe with league details if
#' the request is successful. Users can use this function to obtain league ID
#' for parameter in other functions.
#'
#' @param league A string specifying the name of the league to be queried.
#' @param apikey A string representing the API key required for authentication
#'        with the API Sports Football API.
#'
#' @return A dataframe containing the league information if the request is
#'         successful. Each row represents a league, and columns include details
#'         such as league id, name, and other relevant information provided by the API.
#'
#' @examples
#' getLeagueInfo("Premier League", apikey)
#'
#' @export
#'
getLeagueInfo <- function(league, apikey) {

  # Construct the URL with query parameters
  url <- paste0("https://v3.football.api-sports.io/leagues?",
                "name=", tolower(gsub(" ", "+", league, fixed = TRUE)))

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
    df <- data.frame(jsonData$response)
    df <- df[, -ncol(df)]

    return(df)
  } else {
    stop("Request failed with status code ", status_code(response))
  }
}


#' Retrieve Team ID by Name
#'
#' This function queries the API Sports Football API to retrieve the ID
#' of a football team by its name. It sends a GET request with the team name
#' as a query parameter and returns the team ID if the request is successful.
#' This is a helper function for other functions taking team Id as parameter.
#'
#' @param team A string specifying the name of the team to be queried.
#' @param apikey A string representing the API key required for authentication
#'        with the API Sports Football API.
#'
#' @return An integer representing the team ID if the request is successful.
#'
#' @examples
#' getTeamId("Manchester United", apikey)
#'
#' @export
#'

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
    team_id <- jsonData$response$team$id

    return(team_id)
  } else {
    stop("Request failed with status code ", status_code(response))
  }
}



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

    if (length(stats) == 0) {
      return(NULL)
    }

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
      )  %>%
      # Set heading background color
      tab_options(
        heading.background.color = "#4C5B5C" # Dark grey for heading
      ) %>%
      # Set body background color
      tab_style(
        style = list(
          cell_fill(color = "#F5F5F5") # Light grey for body
        ),
        locations = cells_body(
          columns = everything()
        ))
    return(gt_table)
  } else {
    stop("Request failed with status code ", status_code(response))
  }
}




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
#' searchPlayer("Neymar", "Paris Saint Germain", "<your_api_key>")
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
    player_info <- data.frame(jsonData$response$player)
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
      ) %>%
      # Set heading background color
      tab_options(
        heading.background.color = "#FFD700"
      ) %>%
      # Change font color in the table body
      tab_style(
        style = cell_text(color = "#1b2668"), # Example: blue font color
        locations = cells_body(
          columns = everything()
        )
      ) %>%
      # Center text in the table body
      tab_style(
        style = cell_text(align = "center"),
        locations = cells_body(columns = 2)
      )

    return(gt_table)
  } else {
    stop("Request failed with status code ", status_code(response))
  }
}




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
#' getPlayerStatistics(276, 2019, 'your_api_key_here')
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
    stats <- jsonData$response$statistics

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
        penalty_missed = statistics$penalty$missed,
        rating = statistics$games$rating
        # Add more fields as needed
      )

      # Append the current tibble to the list
      statistics_list[[i]] <- statistics_tbl
    }

    # Combine all tibbles in the list into one dataframe
    df <- t(bind_rows(statistics_list))
    df <- as.data.frame(df, stringsAsFactors = FALSE)

    # Creating the gt table to make the output prettier
    player_name <- paste(jsonData$response$player$firstname,
                         jsonData$response$player$lastname)
    gt_table <- df %>%
      gt(rownames_to_stub = T) %>%
      tab_header(
        title = player_name,
        subtitle = paste("Season", season)
      ) %>%
      tab_options(
        column_labels.hidden = TRUE
      ) %>%
      # Set heading background color
      tab_options(
        heading.background.color = "#1b2668"
      ) %>%
      tab_style(
        style = cell_fill(color = "#FFD700"),
        locations = cells_body(
          rows = nrow(df),
          columns = everything()
        )
      )

    return(gt_table)
  } else {
    stop("Request failed with status code ", status_code(response))
  }
}
