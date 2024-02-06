# Load required libraries
library(testthat)
library(httr)

# Mock API Key
mock_api_key <- "mock_api_key_12345"

# locate the script
source("../../R/zerui_script.R")

#### Test Cases for getLeagueInfo
test_that("getLeagueId returns correct league ID for known league name", {
  league_name <- "Premier League"
  result <- getLeagueInfo(league_name, mock_api_key)
  expect_true(is.list(result))
  expect_true(nrow(result) > 0)
})

test_that("getLeagueId handles invalid league names gracefully", {
  league_name <- "Nonexistent League"
  result <- getLeagueInfo(league_name, mock_api_key)
  expect_equal(nrow(result), 0)
})

test_that("getLeagueId handles empty league name", {
  league_name <- ""
  result <- getLeagueInfo(league_name, mock_api_key)
  expect_equal(nrow(result), 0)
})


#### Test Cases for getTeamId
test_that("getTeamId returns correct team ID for known team name", {
  team_name <- "Manchester United"
  result <- getTeamId(team_name, mock_api_key)
  expect_true(is.numeric(result))
})

test_that("getTeamId handles invalid team names gracefully", {
  team_name <- "Nonexistent Team"
  result <- getTeamId(team_name, mock_api_key)
  expect_null(result)
})

test_that("getTeamId handles empty team name", {
  team_name <- ""
  result <- getTeamId(team_name, mock_api_key)
  expect_null(result)
})


#### Test Cases for getTeamStatistics
test_that("getTeamStatistics returns statistics for a given team", {
  league_id <- 39
  season <- 2019
  team <- "Manchester United"
  result <- getTeamStatistics(league_id, season, team, mock_api_key)
  expect_is(result, "gt_tbl")
  expect_true(!is.null(result))
})


#### Test Cases for searchPlayer
test_that("searchPlayer returns player information for a known player", {
  player <- "Neymar"
  team <- "Paris Saint Germain"
  result <- searchPlayer(player, team, mock_api_key)
  expect_is(result, "gt_tbl")
  expect_true(!is.null(result))
})


#### Test Cases for getPlayerStatistics
test_that("getPlayerStatistics returns statistics for a given player", {
  player_id <- 276
  season <- 2019
  result <- getPlayerStatistics(player_id, season, mock_api_key)
  expect_is(result, "gt_tbl")
  expect_true(!is.null(result))
})
