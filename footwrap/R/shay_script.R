# Load libraries
library(httr)
library(tidyverse)
library(ggplot2)
library(jsonlite)

#' Safe API Call Wrapper
#'
#' This function is a wrapper for making API calls safely. It uses tryCatch to handle errors gracefully.
#'
#' @param call A function that represents the API call.
#'
#' @return The result of the API call if successful; NULL otherwise.
#' @export
#'
#' @examples
#' safeApiCall(function() {
#'   httr::GET("https://api.example.com/data")
#' })
safeApiCall <- function(call) {
  tryCatch({
    call()
  }, error = function(e) {
    message("An error occurred: ", e$message)
    return(NULL)
  })
}

# 1) Creating a function of the capacities of the venues by country
#' Get Largest Venues by Country
#'
#' This function retrieves the largest venues in a specified country using an API call.
#'
#' @param country_name The name of the country for which to retrieve venue information.
#' @param top The number of top venues to retrieve.
#' @param api_key The API key for making the API call.
#'
#' @return A ggplot object representing the capacity of the venues.
#' @export
#'
#' @examples
#' GetBiggestVenues("England", 5, "your_api_key")
GetBiggestVenues <- function(country_name, top, api_key){

  # Convert country_name to string and top to integer
  country_name <- as.character(country_name)
  top <- as.integer(top)

  # Check if conversion is successful
  if (is.na(top)) {
    stop("top should be an integer value.")
  }

  # Obtaining the venue data of the specific country
  url <- "https://api-football-v1.p.rapidapi.com/v3/venues"
  queryString <- list(country = country_name) # Set the country name parameter

  response <- safeApiCall(function() {
    VERB("GET", url, query = queryString, add_headers('X-RapidAPI-Key' = api_key,
                                                      'X-RapidAPI-Host' = 'api-football-v1.p.rapidapi.com'), content_type("application/octet-stream"))
  })
  if (is.null(response)) return(NULL)

  raw_data <- content(response, "text")
  parsed <- fromJSON(raw_data)

  # Extract the data frame
  df <- parsed$response

  # Sort data frame in descending order
  df <- df %>%
    arrange(desc(capacity)) %>%
    slice(1:top)

  top_venue_bar <- ggplot(df, aes(x=reorder(name, capacity), y=capacity)) +
    geom_bar(stat='identity', fill = "navy") +
    labs(title = "Capacity of Venues", y="Capacity (persons)", x="Venue Names") +
    coord_flip()
  return(top_venue_bar) # Display the bar chart
}



# 2) Obtain a cleaned data frame of coach information
#' Get Coach Information for a Team
#'
#' This function fetches information about coaches for a specified team.
#'
#' @param team_id The ID of the team for which to fetch coach information.
#' @param api_key The API key for accessing the data.
#'
#' @return A data frame containing coach information.
#' @export
#'
#' @examples
#' GetCoachInfo("team_id_example", "your_api_key")
GetCoachInfo <- function(team_id, api_key){

  # Convert team_id to a string
  team_id <- as.character(team_id)

  url <- "https://api-football-v1.p.rapidapi.com/v3/coachs"
  queryString <- list(team = team_id) # Set the team id parameter

  response <- safeApiCall(function() {
    VERB("GET", url, query = queryString, add_headers('X-RapidAPI-Key' = api_key,
                                                      'X-RapidAPI-Host' = 'api-football-v1.p.rapidapi.com'), content_type("application/octet-stream"))
  })
  if (is.null(response)) return(NULL)

  raw_data <- content(response, "text")
  parsed <- fromJSON(raw_data)

  # Extract the data frame
  df <- parsed$response

  # Unnesting birth and team, then selecting relevant information
  df <- df %>%
    unnest(birth, names_sep="_") %>%
    unnest(team, names_sep="_") %>%
    select(firstname, lastname, age, birth_date, birth_place, birth_country, nationality, team_name)
  return(df) # Display the data frame
}


# 3) Compare the number of trophies between 2 players
#' Compare Trophies Between Two Players
#'
#' This function compares the number of trophies won by two players.
#'
#' @param player_id_1 The ID of the first player.
#' @param player_id_2 The ID of the second player.
#' @param api_key The API key used for making the API call.
#'
#' @return A ggplot object visualizing the number of trophies won by each player.
#' @export
#'
#' @examples
#' CompareTrophies("player1_id", "player2_id", "your_api_key")
CompareTrophies <- function(player_id_1, player_id_2, api_key){

  # Convert player_id_1 and player_id_2 to strings
  player_id_1 <- as.character(player_id_1)
  player_id_2 <- as.character(player_id_2)

  url <- "https://api-football-v1.p.rapidapi.com/v3/trophies"

  # Obtaining the data of player 1
  queryString1 <- list(player = player_id_1)
  response1 <- safeApiCall(function() {
    VERB("GET", url, query = queryString1, add_headers('X-RapidAPI-Key' = api_key,
                                                       'X-RapidAPI-Host' = 'api-football-v1.p.rapidapi.com'), content_type("application/octet-stream"))
  })
  if (is.null(response1)) return(NULL)

  raw_data1 <- content(response1, "text")
  parsed1 <- fromJSON(raw_data1)
  df1 <- parsed1$response

  # Obtaining the data of player 2
  queryString2 <- list(player = player_id_2)
  response2 <- safeApiCall(function() {
    VERB("GET", url, query = queryString2, add_headers('X-RapidAPI-Key' = api_key,
                                                       'X-RapidAPI-Host' = 'api-football-v1.p.rapidapi.com'), content_type("application/octet-stream"))
  })
  if (is.null(response2)) return(NULL)

  raw_data2 <- content(response2, "text")
  parsed2 <- fromJSON(raw_data2)
  df2 <- parsed2$response

  # Create a data frame of the two players
  trophy <- data.frame(
    player_id = c(player_id_1, player_id_2),
    n_trophy = c(nrow(df1), nrow(df2))
  )

  # Compare the lengths of player 1 to player 2
  if (nrow(df1) > nrow(df2)){
    # If player 1 has more trophies than player 2
    cat("Player", player_id.1, "has", nrow(df1) - nrow(df2), "more trophies than player", player_id.2)

    bigger_bar <- ggplot(trophy, aes(x=reorder(player_id, n_trophy, FUN = desc), y=n_trophy)) +
      geom_col(fill = "green") +
      labs(title = "Number of Trophies Won by Player", x = "Player ID", y = "Number of Trophies")
    bigger_bar

    # If player 1 has equal amount of trophies as player 2
  } else if (nrow(df1) == nrow(df2)){
    cat("Both player", player_id.1, "and player", player_id.2, "have", nrow(df1), "trophies")

    same_bar <- ggplot(trophy, aes(x=player_id, y=n_trophy)) +
      geom_col(fill="grey") +
      labs(title = "Number of Trophies Won by Player", x = "Player ID", y = "Number of Trophies")
    same_bar

    # If player 1 has less trophies than player 2
  } else {
    cat("Player", player_id.1, "has", nrow(df2) - nrow(df1), "less trophies than player", player_id.2)

    smaller_bar <- ggplot(trophy, aes(x=reorder(player_id, n_trophy), y=n_trophy)) +
      geom_col(fill = "red") +
      labs(title = "Number of Trophies Won by Player", x = "Player ID", y = "Number of Trophies")
    smaller_bar
  }
}
