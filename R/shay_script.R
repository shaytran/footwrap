# Load libraries
library(httr)
library(tidyverse)
library(ggplot2)
library(jsonlite)

##' Get Largest Venues by Country
#'
#' Retrieves the largest venues in a specified country. This function can
#' operate with actual API calls or use mock data for testing purposes when
#' supplied with "mock_api_key" as the API key.
#'
#' @param country_name The name of the country for which to retrieve venue information.
#' @param top The number of top venues to retrieve.
#' @param api_key The API key for making the API call or "mock_api_key" for using mock data.
#'
#' @return A ggplot object visualizing the capacities of the largest venues.
#' @examples
#' # Using mock API key for demonstration; replace "mock_api_key" with your actual API key.
#' GetBiggestVenues("England", 5, "mock_api_key")
#' @export
GetBiggestVenues <- function(country_name, top, api_key){
  if (api_key == "mock_api_key") {
    mock_response_venues <- '{"get":"venues","parameters":{"country":"England"},"errors":[],"results":783,"paging":{"current":1,"total":1},"response":[{"id":489,"name":"Wembley Stadium","address":"Stadium Way, Wembley, Brent","city":"London","country":"England","capacity":90000,"surface":"grass","image":"https://media.api-sports.io/football/venues/489.png"}]}'
    parsed <- fromJSON(mock_response_venues)
  } else {
    # Placeholder for actual API call logic
  }
  df <- parsed$response
  df <- df %>%
    arrange(desc(capacity)) %>%
    slice(1:top)

  top_venue_bar <- ggplot(df, aes(x=reorder(name, capacity), y=capacity)) +
    geom_bar(stat='identity', fill = "navy") +
    labs(title = "Capacity of Venues", y="Capacity (persons)", x="Venue Names") +
    coord_flip()
  return(top_venue_bar)
}

#' Get Coach Information for a Team
#'
#' Fetches information about the coaches for a specified team. This function can
#' use actual API calls or mocked data for testing when supplied with "mock_api_key"
#' as the API key.
#'
#' @param team_id The ID of the team for which to fetch coach information.
#' @param api_key The API key for accessing the data or "mock_api_key" for using mock data.
#'
#' @return A data frame containing coach information.
#' @examples
#' # Using mock API key for demonstration; replace "mock_api_key" with your actual API key.
#' GetCoachInfo("team_id_example", "mock_api_key")
#' @export
GetCoachInfo <- function(team_id, api_key){
  if (api_key == "mock_api_key") {
    mock_response_coaches <- '{"get":"coachs","parameters":{"team":"33"},"errors":[],"results":2,"paging":{"current":1,"total":1},"response":[{"id":19,"name":"O. Solskj\u00e6r","firstname":"Ole Gunnar","lastname":"Solskj\u00e6r","age":50,"birth":{"date":"1973-02-26","place":"Kristiansund","country":"Norway"},"nationality":"Norway","height":null,"weight":null,"photo":"https://media.api-sports.io/football/coachs/19.png","team":{"id":33,"name":"Manchester United","logo":"https://media.api-sports.io/football/teams/33.png"},"career":[{"team":{"id":33,"name":"Manchester United","logo":"https://media.api-sports.io/football/teams/33.png"},"start":"2018-12-01","end":"2021-11-01"}]}]}'
    parsed <- fromJSON(mock_response_coaches)
  } else {
    # Placeholder for actual API call logic
  }
  df <- parsed$response
  df <- df %>%
    unnest(birth, names_sep="_") %>%
    unnest(team, names_sep="_") %>%
    select(firstname, lastname, age, birth_date, birth_place, birth_country, nationality, team_name)
  return(df)
}

#' Compare Trophies Between Two Players
#'
#' Compares the number of trophies won by two players. This function can operate
#' with actual API calls or use mock data for testing purposes when supplied with
#' "mock_api_key" as the API key.
#'
#' @param player_id_1 The ID of the first player.
#' @param player_id_2 The ID of the second player.
#' @param api_key The API key used for making the API call or "mock_api_key" for using mock data.
#'
#' @return A ggplot object visualizing the number of trophies won by each player.
#' @examples
#' # Using mock API key for demonstration; replace "mock_api_key" with your actual API key.
#' CompareTrophies("player1_id", "player2_id", "mock_api_key")
#' @export
CompareTrophies <- function(player_id_1, player_id_2, api_key){
  if (api_key == "mock_api_key") {
    mock_response_trophies <- '{"get":"trophies","parameters":{"player":"276"},"errors":[],"results":49,"paging":{"current":1,"total":1},"response":[{"league":"CONMEBOL U20","country":"South-America","season":"Peru 2011","place":"Winner"}]}'
    parsed1 <- fromJSON(mock_response_trophies)
    parsed2 <- fromJSON(mock_response_trophies) # Assuming the same response for simplicity
  } else {
    # Placeholder for actual API call logic
  }
  df1 <- parsed1$response
  df2 <- parsed2$response # Assuming df2 should be derived from parsed2
  trophy <- data.frame(
    player_id = c(player_id_1, player_id_2),
    n_trophy = c(length(df1), length(df2)) # Adjust based on actual structure of parsed JSON
  )

  ggplot(trophy, aes(x=reorder(player_id, n_trophy, FUN = desc), y=n_trophy)) +
    geom_col(fill = "steelblue") +
    labs(title = "Number of Trophies Won by Player", x = "Player ID", y = "Number of Trophies")
}


