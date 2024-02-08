library(testthat)
library(webmockr)

# Setting the API key from environment variable
mock_api_key <- "MOCK_API_KEY"
source("../../R/matt_script.R") # Ensure this path correctly points to your script

# Enable webmockr to intercept HTTP requests
webmockr::enable()

##### Mock setup and test for getTopScorers
stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/players/topscorers?league=39&season=2020") %>%
  to_return(body = '{
    "get": "players/topscorers",
    "parameters": {"league": "39", "season": "2020"},
    "errors": [],
    "results": 20,
    "paging": {"current": 0, "total": 1},
    "response": [{"player": {"id": 184, "name": "H. Kane", "firstname": "Harry Edward", "lastname": "Kane", "age": 31, "birth": {"date": "1993-07-28", "place": "London", "country": "England"}, "nationality": "England", "height": "188 cm", "weight": "86 kg", "injured": false, "photo": "https://media.api-sports.io/football/players/184.png"}, "statistics": [{"team": {"id": 47, "name": "Tottenham", "logo": "https://media.api-sports.io/football/teams/47.png"},
                  "league": {"id": 39, "name": "Premier League", "country": "England", "logo": "https://media.api-sports.io/football/leagues/39.png", "flag": "https://media.api-sports.io/flags/gb.svg", "season": 2020}, "games": {"appearances": 35, "lineups": 35, "minutes": 3087, "number": null, "position": "Attacker", "rating": "7.642857", "captain": false}, "substitutes": {"in": 0, "out": 5, "bench": 0}, "shots":
                  {"total": 110, "on": 53}, "goals": {"total": 23, "conceded": 0, "assists": 14, "saves": null}, "passes": {"total": 909, "key": 51, "accuracy": 18}, "tackles": {"total": 22, "blocks": 11, "interceptions": 11}, "duels": {"total": 466, "won": 209}, "dribbles": {"attempts": 100, "success": 52, "past": null}, "fouls": {"drawn": 60, "committed": 26}, "cards": {"yellow": 1, "yellowred": 0, "red": 0},
                  "penalty": {"won": null, "committed": null, "scored": 4, "missed": 0, "saved": null}}]}
    ]}', status = 200)

test_that("getTopScorers returns a data frame", {
  league <- 39
  season <- 2020

  result <- getTopScorers(league, season, mock_api_key)

  expect_true(is.data.frame(result))
  # expect_equal(ncol(result), 11)
  # expect_true(all(c("firstname", "lastname", "nationality", "position", "team_name", "league_name", "appearances", "goals_total", "assists", "shots_total", "shots_on") %in% names(result)))
})

##### Mock setup for getTopAssists
stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/players/topassists?league=39&season=2020") %>%
  to_return(body = '{
    "get": "players/topassists",
    "parameters": {"league": "39", "season": "2020"},
    "errors": [],
    "results": 20,
    "paging": {"current": 0, "total": 1},
    "response": [{
        "player": {
            "id": 184,
            "name": "H. Kane",
            "firstname": "Harry Edward",
            "lastname": "Kane",
            "age": 31,
            "birth": {
                "date": "1993-07-28",
                "place": "London",
                "country": "England"
            },
            "nationality": "England",
            "height": "188 cm",
            "weight": "86 kg",
            "injured": false,
            "photo": "https://media.api-sports.io/football/players/184.png"
        },
        "statistics": [{
            "team": {
                "id": 47,
                "name": "Tottenham",
                "logo": "https://media.api-sports.io/football/teams/47.png"
            },
            "league": {
                "id": 39,
                "name": "Premier League",
                "country": "England",
                "logo": "https://media.api-sports.io/football/leagues/39.png",
                "flag": "https://media.api-sports.io/flags/gb.svg",
                "season": 2020
            },
            "games": {
                "appearances": 35,
                "lineups": 35,
                "minutes": 3087,
                "number": null,
                "position": "Attacker",
                "rating": "7.642857",
                "captain": false
            },
            "substitutes": {
                "in": 0,
                "out": 5,
                "bench": 0
            },
            "shots": {
                "total": 110,
                "on": 53
            },
            "goals": {
                "total": 23,
                "conceded": 0,
                "assists": 14,
                "saves": null
            },
            "passes": {
                "total": 909,
                "key": 51,
                "accuracy": 18
            },
            "tackles": {
                "total": 22,
                "blocks": 11,
                "interceptions": 11
            },
            "duels": {
                "total": 466,
                "won": 209
            },
            "dribbles": {
                "attempts": 100,
                "success": 52,
                "past": null
            },
            "fouls": {
                "drawn": 60,
                "committed": 26
            },
            "cards": {
                "yellow": 1,
                "yellowred": 0,
                "red": 0
            },
            "penalty": {
                "won": null,
                "committed": null,
                "scored": 4,
                "missed": 0,
                "saved": null
            }
        }]
    }]
  }', status = 200)

test_that("getTopAssists returns a data frame", {
  league <- 39
  season <- 2020
  result <- getTopAssists(league, season, mock_api_key)
  expect_true(is.data.frame(result))
})


##### Mock setup for getTeamTransfers
stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/transfers?team=33") %>%
  to_return(body = '{
    "get": "transfers",
    "parameters": {"team": "33"},
    "errors": [],
    "results": 227,
    "paging": {"current": 1, "total": 1},
    "response": [
        {
            "player": {
                "id": 19285,
                "name": "L. Steele"
            },
            "update": "2023-04-05T04:02:27+00:00",
            "transfers": [
                {
                    "date": "2006-08-10",
                    "type": "€ 250K",
                    "teams": {
                        "in": {
                            "id": 60,
                            "name": "West Brom",
                            "logo": "https://media.api-sports.io/football/teams/60.png"
                        },
                        "out": {
                            "id": 33,
                            "name": "Manchester United",
                            "logo": "https://media.api-sports.io/football/teams/33.png"
                        }
                    }
                }
            ]
        }
    ]
}', status = 200)

test_that("getTeamTransfers returns a data frame", {
  team <- 33
  result <- getTeamTransfers(team, mock_api_key)
  expect_true(is.data.frame(result))
})


