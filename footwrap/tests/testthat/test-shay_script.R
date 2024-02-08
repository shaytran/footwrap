library(testthat)
library(webmockr)

# Setting the API key from environment variable
mock_api_key <- "MOCK_API_KEY"
source("../../R/shay_script.R") # Ensure this path correctly points to your script

# Enable webmockr to intercept HTTP requests
webmockr::enable()

##### Mock setup for GetBiggestVenues
stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/venues?country=England") %>%
  to_return(body = '{
    "get": "venues",
    "parameters": {"country": "England"},
    "errors": [],
    "results": 783,
    "paging": {"current": 1, "total": 1},
    "response": [
      {"id": 489, "name": "Wembley Stadium", "capacity": 90000},
      {"id": 556, "name": "Old Trafford", "capacity": 76212},
      {"id": 562, "name": "St. James\' Park", "capacity": 52758},
      {"id": 504, "name": "Vitality Stadium", "capacity": 12000}
    ]
  }', status = 200)

# Test for GetBiggestVenues function
test_that("GetBiggestVenues returns the correct structure", {
  country_name <- "England" # Corrected to match the mock setup
  top_venues <- 4 # Adjusted for the mock response

  result <- GetBiggestVenues(country_name, top_venues, mock_api_key)

  # Expect that the result is a ggplot object
  expect_true(is.ggplot(result))
})

#### Mock setup for GetCoachInfo for team 33
stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/coachs?team=33") %>%
  to_return(body = '{
    "get": "coachs",
    "parameters": {"team": "33"},
    "errors": [],
    "results": 2,
    "paging": {"current": 1, "total": 1},
    "response": [
      {
        "id": 19,
        "name": "O. Solskjær",
        "firstname": "Ole Gunnar",
        "lastname": "Solskjær",
        "age": 50,
        "birth": {"date": "1973-02-26", "place": "Kristiansund", "country": "Norway"},
        "nationality": "Norway",
        "photo": "https://media.api-sports.io/football/coachs/19.png",
        "team": {"id": 33, "name": "Manchester United", "logo": "https://media.api-sports.io/football/teams/33.png"}
      },
      {
        "id": 1993,
        "name": "E. ten Hag",
        "firstname": "Erik",
        "lastname": "ten Hag",
        "age": 53,
        "birth": {"date": "1970-02-02", "place": "Haaksbergen", "country": "Netherlands"},
        "nationality": "Netherlands",
        "photo": "https://media.api-sports.io/football/coachs/1993.png",
        "team": {"id": 33, "name": "Manchester United", "logo": "https://media.api-sports.io/football/teams/33.png"}
      }
    ]
  }', status = 200)

# Test for GetCoachInfo function
test_that("GetCoachInfo successfully returns a gt table", {
  team_id <- "33"

  result <- GetCoachInfo(team_id, mock_api_key)

  # Check that the result is of the correct class for a gt table
  expect_true(inherits(result, "gt_tbl"))
})

#### Mock setup for CompareTrophies for player 276
stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/trophies?player=276") %>%
  to_return(body = '{
    "get": "trophies",
    "parameters": {"player": "276"},
    "errors": [],
    "results": 49,
    "paging": {"current": 1, "total": 1},
    "response": [
      {"league": "CONMEBOL U20", "country": "South-America", "season": "Peru 2011", "place": "Winner"},
      {"league": "Trophée des Champions", "country": "France", "season": "2022/2023", "place": "Winner"},
      {"league": "Ligue 1", "country": "France", "season": "2022/2023", "place": "Winner"},
      {"league": "Ligue 1", "country": "France", "season": "2021/2022", "place": "Winner"}
    ]
  }', status = 200)

#### Corrected Mock setup for CompareTrophies for player 260
stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/trophies?player=260") %>%
  to_return(body = '{
    "get":"trophies",
    "parameters":{"player":"260"},
    "errors":[],
    "results":13,
    "paging":{"current":1,"total":1},
    "response":[
        {"league":"Ligue 1","country":"France","season":"2021/2022","place":"Winner"},
        {"league":"Trophée des Champions","country":"France","season":"2021/2022","place":"2nd Place"},
        {"league":"Ligue 1","country":"France","season":"2020/2021","place":"2nd Place"},
        {"league":"Coupe de France","country":"France","season":"2020/2021","place":"Winner"},
        {"league":"Trophée des Champions","country":"France","season":"2020/2021","place":"Winner"},
        {"league":"Ligue 1","country":"France","season":"2019/2020","place":"Winner"},
        {"league":"Coupe de France","country":"France","season":"2019/2020","place":"Winner"},
        {"league":"Trophée des Champions","country":"France","season":"2019/2020","place":"Winner"},
        {"league":"Coupe de la Ligue","country":"France","season":"2019/2020","place":"Winner"},
        {"league":"UEFA Champions League","country":"Europe","season":"2019/2020","place":"2nd Place"},
        {"league":"Ligue 1","country":"France","season":"2018/2019","place":"Winner"},
        {"league":"Coupe de France","country":"France","season":"2018/2019","place":"2nd Place"},
        {"league":"Trophée des Champions","country":"France","season":"2018/2019","place":"Winner"}
      ]
    }', status = 200)

# Test for CompareTrophies function
test_that("CompareTrophies generates a plot", {
  player_id_1 <- "276"
  player_id_2 <- "260"

  result <- CompareTrophies(player_id_1, player_id_2, mock_api_key)

  # Expect that the result is a ggplot object
  expect_true(is.ggplot(result))
})

# Disable webmockr after tests
webmockr::disable()

