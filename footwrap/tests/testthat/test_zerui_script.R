# Load required libraries
library(testthat)
library(webmockr)

source("../../R/zerui_script.R")
mock_api_key <- "MOCK_API_KEY"

# Enable webmockr to intercept HTTP requests
webmockr::enable()

#### Mock setup for getLeagueInfo
# mock for valid name
stub_request("get", 
             "https://v3.football.api-sports.io/leagues?name=world+cup") %>%
  to_return(body = '{
    "get": "leagues",
    "parameters": {
      "name": "World Cup"
    },
    "errors": [],
    "results": 0,
    "paging": {
      "current": 1,
      "total": 1
    },
    "response": [
      {
        "league": {
          "id": 1,
          "name": "World Cup",
          "type": "Cup",
          "logo": "https://media.api-sports.io/football/leagues/1.png"
        },
        "country": {
          "name": "World",
          "code": null,
          "flag": null
        }}]
  }', status = 200)

# mock for invalid name
stub_request("get", 
             "https://v3.football.api-sports.io/leagues?name=fake+name") %>%
  to_return(body = '{
    "get": "leagues",
    "parameters": {
      "name": "Fake name"
    },
    "errors": [],
    "results": 0,
    "paging": {
      "current": 1,
      "total": 1
    },
    "response": []
  }', status = 200)

# mock for empty name
stub_request("get", 
             "https://v3.football.api-sports.io/leagues?name=") %>%
  to_return(body = '{
    "get": "leagues",
    "parameters": {
      "name": ""
    },
    "errors": [],
    "results": 0,
    "paging": {
      "current": 1,
      "total": 1
    },
    "response": []
  }', status = 200)


#### Test Cases for getLeagueInfo
test_that("getLeagueId returns correct league ID for known league name", {
  league_name <- "World Cup"
  result <- getLeagueInfo(league_name, mock_api_key)
  expect_true(is.list(result))
  expect_true(nrow(result) > 0)
})

test_that("getLeagueId handles invalid league names gracefully", {
  league_name <- "Fake name"
  result <- getLeagueInfo(league_name, mock_api_key)
  expect_equal(nrow(result), 0)
})

test_that("getLeagueId handles empty league name", {
  league_name <- ""
  result <- getLeagueInfo(league_name, mock_api_key)
  expect_equal(nrow(result), 0)
})



#### Mock setup for getTeamId
# mock for valid name
stub_request("get", "https://v3.football.api-sports.io/teams?name=manchester+united") %>%
  to_return(body = '{
    "get": "teams",
    "parameters": {
      "name": "Manchester United"
    },
    "errors": [],
    "results": 1,
    "paging": {
      "current": 1,
      "total": 1
    },
    "response": [
      {
        "team": {
          "id": 33,
          "name": "Manchester United",
          "code": "MUN",
          "country": "England",
          "founded": 1878,
          "national": false
        }
      }
    ]
  }', status = 200)

# mock for invalid name
stub_request("get", "https://v3.football.api-sports.io/teams?name=fake") %>%
  to_return(body = '{
    "get": "teams",
    "parameters": {
      "name": "Fake"
    },
    "errors": [],
    "results": 0,
    "paging": {
      "current": 1,
      "total": 1
    },
    "response": []
  }', status = 200)

# mock for empty name
stub_request("get", "https://v3.football.api-sports.io/teams?name=") %>%
  to_return(body = '{
    "get": "teams",
    "parameters": {
      "name": ""
    },
    "errors": [],
    "results": 0,
    "paging": {
      "current": 1,
      "total": 1
    },
    "response": []
  }', status = 200)

#### Test Cases for getTeamId
test_that("getTeamId returns correct team ID for known team name", {
  team_name <- "Manchester United"
  result <- getTeamId(team_name, mock_api_key)
  expect_true(is.numeric(result))
})

test_that("getTeamId handles invalid team names gracefully", {
  team_name <- "Fake"
  result <- getTeamId(team_name, mock_api_key)
  expect_null(result)
})

test_that("getTeamId handles empty team name", {
  team_name <- ""
  result <- getTeamId(team_name, mock_api_key)
  expect_null(result)
})



#### Mock set up for getTeamStatistics
stub_request("get", "https://v3.football.api-sports.io/teams/statistics?league=39&season=2019&team=33") %>%
  to_return(body = '{
    "get": "teams/statistics",
    "parameters": {"league": "39", "season": "2019", "team": "33"},
    "response": {
      "league": {"id": null, "name": null, "country": null, "logo": null, "flag": null, "season": null},
      "team": {"id": null, "name": null, "logo": null},
      "form": null,
      "fixtures": {
        "played": {"home": 0, "away": 0, "total": 0},
        "wins": {"home": 0, "away": 0, "total": 0},
        "draws": {"home": 0, "away": 0, "total": 0},
        "loses": {"home": 0, "away": 0, "total": 0}
      },
      "goals": {
        "for": {
          "total": {"home": 0, "away": 0, "total": 0},
          "average": {"home": "0.0", "away": "0.0", "total": "0.0"}
        },
        "against": {
          "total": {"home": 0, "away": 0, "total": 0},
          "average": {"home": "0.0", "away": "0.0", "total": "0.0"}
        }
      }
    }
  }', status = 200)

#### Test Cases for getTeamStatistics
test_that("getTeamStatistics returns statistics for a given team", {
  league_id <- 39
  season <- 2019
  team <- "Manchester United"
  result <- getTeamStatistics(league_id, season, team, mock_api_key)
  expect_is(result, "gt_tbl")
  expect_true(!is.null(result))
})



#### Mock set up for searchPlayer
stub_request("get", "https://v3.football.api-sports.io/players?team=33&search=neymar") %>%
  to_return(body = '{
    "get": "players",
    "response": [
      {
        "player": {}
      }
    ]
  }', status = 200)

#### Test Cases for searchPlayer
test_that("searchPlayer returns player information for a known player", {
  player <- "Neymar"
  team <- "Manchester United"
  result <- searchPlayer(player, team, mock_api_key)
  expect_is(result, "gt_tbl")
  expect_true(!is.null(result))
})



#### Mock set up for getPlayerStatistics
stub_request("get", "https://v3.football.api-sports.io/players?id=276&season=2019") %>%
  to_return(body = '{
  "get": "players",
  "response": [{
    "player": {},
    "statistics": [{
      "team": {"id": 85, "name": "Paris Saint Germain"},
      "league": {"id": 61, "name": "Ligue 1", "country": "France"},
      "games": {"appearences": 15, "lineups": 15, "minutes": 1322, "position": "Attacker", "rating": "8.053333", "captain": false},
      "substitutes": {"in": 0, "out": 3, "bench": 0},
      "shots": {"total": 70, "on": 36},
      "goals": {"total": 13, "assists": 6},
      "passes": {"total": 704, "key": 39, "accuracy": 79},
      "tackles": {"total": 13, "blocks": 0, "interceptions": 4},
      "duels": {"total": null, "won": null},
      "dribbles": {"attempts": 143, "success": 88},
      "fouls": {"drawn": 62, "committed": 14},
      "cards": {"yellow": 3, "yellowred": 1, "red": 0},
      "penalty": {"won": 1, "scored": 4, "missed": 1}
    }]}]}', status = 200)

#### Test Cases for getPlayerStatistics
test_that("getPlayerStatistics returns statistics for a given player", {
  player_id <- 276
  season <- 2019
  result <- getPlayerStatistics(player_id, season, mock_api_key)
  expect_is(result, "gt_tbl")
  expect_true(!is.null(result))
})

# Disable webmockr after tests
webmockr::disable()
