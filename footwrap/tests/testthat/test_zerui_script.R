library(testthat)
library(httr)

apikey <- 'c2fc2c53bc1c1a2a3b15124124996cbd'

# locate the script
source("/Users/zeruizhang/DATA534_Project_Group8/footwrap/R/zerui_script.R")

test_that("getLeagueId returns correct league ID for known league name", {
  league_name <- "Premier League"
  result <- getLeagueId(league_name, apikey)
  expect_true(is.list(result))
  expect_true(length(result) > 0)
})

test_that("getLeagueId handles invalid league names gracefully", {
  league_name <- "Nonexistent League"
  result <- getLeagueId(league_name, apikey)
  expect_equal(length(result), NULL) 
})

test_that("getLeagueId handles empty league name", {
  league_name <- ""
  result <- getLeagueId(league_name, apikey)
  expect_equal(length(result), NULL) 
})



test_that("getTeamId returns correct team ID for known team name", {
  team_name <- "Liverpool"
  result <- getTeamId(team_name, apikey)
  expect_true(is.list(result))
  expect_true(length(result) > 0)
})

test_that("getTeamId handles invalid team names gracefully", {
  team_name <- "Nonexistent Team"
  result <- getTeamId(team_name, apikey)
  expect_equal(length(result), 0)
})

test_that("getTeamId handles empty team name", {
  team_name <- ""
  result <- getTeamId(team_name, apikey)
  expect_equal(length(result), 0)
})



test_that("getTeamStatistics returns statistics for a given team ID", {
  team_id <- 39
  season <- 2021
  result <- getTeamStatistics(team_id, season, apikey)
  expect_is(result, "list")
  expect_true(!is.null(result$statistics))
})

test_that("getTeamStatistics handles invalid team IDs gracefully", {
  team_id <- -1 
  season <- 2021
  result <- getTeamStatistics(team_id, season, apikey)
  expect_null(result$statistics) 
})

test_that("getTeamStatistics handles requests for future seasons", {
  team_id <- 40 
  season <- 3000 
  result <- getTeamStatistics(team_id, season, apikey)
  expect_null(result$statistics)
})



test_that("searchPlayer returns player information for a known player", {
  player_name <- "Mohamed Salah" 
  result <- searchPlayer(player_name, apikey)
  expect_is(result, "list")
  expect_true(length(result) > 0)
  expect_true(all(c("id", "name", "team_id") %in% names(result[[1]])))
})

test_that("searchPlayer handles special characters in player name", {
  player_name <- "@#$%^&*()"
  result <- searchPlayer(player_name, apikey)
  expect_equal(length(result), 0)
})



test_that("getPlayerStatistics returns statistics for a given player", {
  player_id <- 377
  season <- 2021
  result <- getPlayerStatistics(player_id, season, apikey)
  expect_is(result, "list")
  expect_true(!is.null(result$statistics))
})

test_that("getPlayerStatistics handles invalid player IDs", {
  player_id <- -1 
  season <- 2021
  result <- getPlayerStatistics(player_id, season, apikey)
  expect_null(result$statistics) 
})

test_that("getPlayerStatistics for future seasons returns no data", {
  player_id <- 377 
  season <- 3000 
  result <- getPlayerStatistics(player_id, season, apikey)
  expect_null(result$statistics) 
})





testthat::test_dir("tests/testthat")

