# Load libraries
library(httr)
library(tidyverse)
library(ggplot2)
library(jsonlite)
library(ggthemes)
library(gt)

##' Get Largest Venues by Country
#'
#' Retrieves the largest venues in a specified country. This function can
#' operate with actual API calls.
#'
#' @param country_name The name of the country for which to retrieve venue information.
#' @param top The number of top venues to retrieve.
#' @param api_key The API key for making the API call
#'
#' @return A ggplot object visualizing the capacities of the largest venues.
#' @examples
#' GetBiggestVenues("England", 5, "api_key")
#' @export
GetBiggestVenues <- function(country_name, top, api_key) {
  country_name <- as.character(country_name)
  top <- as.integer(top)

  if (is.na(top)) {
    stop("Top should be an integer value.")
  }

  url <- "https://api-football-v1.p.rapidapi.com/v3/venues"
  queryString <- list(country = country_name) # Set the country name parameter

  response <- tryCatch({
    GET(url, query = queryString,
        add_headers('X-RapidAPI-Key' = api_key,
                    'X-RapidAPI-Host' = 'api-football-v1.p.rapidapi.com'),
        content_type("application/json"))
  }, error = function(e) {
    message("Error in API call: ", e$message)
    return(NULL)
  })

  if (is.null(response)) return(NULL)

  if (status_code(response) != 200) {
    stop("Failed to fetch data: HTTP status code ", status_code(response))
  }

  raw_data <- content(response, "text")
  parsed <- fromJSON(raw_data, flatten = TRUE)

  df <- parsed$response

  if (length(df) == 0) {
    stop("No data returned from the API.")
  }

  df <- df %>%
    arrange(desc(capacity)) %>%
    slice(1:top)

  top_venue_bar <- ggplot(df, aes(x=reorder(name, capacity), y=capacity)) +
    geom_bar(stat='identity', fill = "navy") +
    theme_wsj() +
    labs(title = "Capacity of Venues", y="Capacity (persons)", x="Venue Names") +
    coord_flip()

  return(top_venue_bar)
}


#' Get Coach Information for a Team
#'
#' Fetches information about the coaches for a specified team. This function can
#' use actual API calls.
#'
#' @param team_id The ID of the team for which to fetch coach information.
#' @param api_key The API key for accessing the data.
#'
#' @return A data frame containing coach information.
#' @examples
#' GetCoachInfo("team_id_example", "api_key")
#' @export
GetCoachInfo <- function(team_id, api_key) {
  # Convert team_id to a string
  team_id <- as.character(team_id)

  url <- "https://api-football-v1.p.rapidapi.com/v3/coachs"
  queryString <- list(team = team_id) # Set the team id parameter

  response <- GET(url, query = queryString,
                  add_headers('X-RapidAPI-Key' = api_key,
                              'X-RapidAPI-Host' = 'api-football-v1.p.rapidapi.com'),
                  content_type("application/json"))

  # Check for successful response
  if (status_code(response) != 200) {
    stop("Failed to fetch data: HTTP status code ", status_code(response))
  }

  raw_data <- content(response, "text", encoding = "UTF-8")
  parsed <- fromJSON(raw_data)

  # Ensure 'parsed' contains the expected data
  if (is.null(parsed$response)) {
    stop("No data found for team_id ", team_id)
  }

  df <- parsed$response

  # Process and select relevant information
  df_processed <- df %>%
    unnest(birth, names_sep = "_") %>%
    unnest(team, names_sep = "_")

  df_selected <- df_processed %>%
    select(
      firstname, lastname, age,
      birth_date = `birth_date`, # adjust based on actual column name
      birth_place = `birth_place`, # adjust based on actual column name
      birth_country = `birth_country`, # adjust based on actual column name
      nationality,
      team_name = `team_name` # adjust based on actual column name
    )

  # Convert to a gt table
  gt_table <- df_selected %>%
    gt() %>%
    tab_header(
      title = "Coach Information",
      subtitle = "Detailed information about team coaches"
    ) %>%
    cols_label(
      firstname = "First Name",
      lastname = "Last Name",
      age = "Age",
      birth_date = "Birth Date",
      birth_place = "Birth Place",
      birth_country = "Country",
      nationality = "Nationality",
      team_name = "Team Name"
    ) %>%
    fmt_date(
      columns = c("birth_date"),
      date_style = 3
    ) %>%
    tab_style(
      style = list(
        cell_fill(color = "darkred"),
        cell_text(color = "white")
      ),
      locations = cells_title(groups = "title")
    ) %>%
    tab_style(
      style = list(
        cell_fill(color = "darkred"),
        cell_text(color = "white")
      ),
      locations = cells_title(groups = "subtitle")
    ) %>%
    tab_style(
      style = cell_fill(color = "lightgray"),
      locations = cells_body(
        columns = everything(),
        rows = TRUE
      )
    ) %>%
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels(
        columns = everything()
      )
    )

  return(gt_table)
}



#' Compare Trophies Between Two Players
#'
#' Compares the number of trophies won by two players. This function can operate
#' with actual API calls.
#'
#' @param player_id_1 The ID of the first player.
#' @param player_id_2 The ID of the second player.
#' @param api_key The API key used for making the API call.
#'
#' @return A ggplot object visualizing the number of trophies won by each player.
#' @examples
#' CompareTrophies("player1_id", "player2_id", "mock_api_key")
#' @export
CompareTrophies <- function(player_id_1, player_id_2, api_key) {
  # Convert player IDs to strings
  player_id_1 <- as.character(player_id_1)
  player_id_2 <- as.character(player_id_2)

  url <- "https://api-football-v1.p.rapidapi.com/v3/trophies"

  # Setup common headers for API requests
  headers <- add_headers(
    'X-RapidAPI-Key' = api_key,
    'X-RapidAPI-Host' = 'api-football-v1.p.rapidapi.com'
  )

  # Obtaining the data of player 1
  response1 <- GET(url, query = list(player = player_id_1), headers, content_type("application/json"))
  if (status_code(response1) != 200) stop("Failed to fetch data for player 1")
  parsed1 <- fromJSON(content(response1, "text", encoding = "UTF-8"))
  df1 <- parsed1$response

  # Obtaining the data of player 2
  response2 <- GET(url, query = list(player = player_id_2), headers, content_type("application/json"))
  if (status_code(response2) != 200) stop("Failed to fetch data for player 2")
  parsed2 <- fromJSON(content(response2, "text", encoding = "UTF-8"))
  df2 <- parsed2$response

  # Create a data frame of the two players
  trophy <- data.frame(
    player_id = c(player_id_1, player_id_2),
    n_trophy = c(nrow(df1), nrow(df2))
  )

  # Visualization with conditional colors
  trophy$color <- ifelse(trophy$n_trophy[1] > trophy$n_trophy[2], "darkgreen", ifelse(trophy$n_trophy[1] == trophy$n_trophy[2], "grey", "red"))

  ggplot(trophy, aes(x = reorder(player_id, n_trophy, FUN = desc), y = n_trophy, fill = color)) +
    geom_col() +
    geom_text(aes(label = n_trophy), position = position_dodge(width = 1.3), vjust = -0.1, color = "black") +
    theme_wsj() +
    scale_fill_identity() +
    labs(title = "Number of Trophies Won by Player", x = "Player ID", y = "Number of Trophies") +
    coord_flip()
}
