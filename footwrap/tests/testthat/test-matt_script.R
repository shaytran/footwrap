library(testthat)

# Setting the API key from environment variable
my_key <- Sys.getenv("FOOTBALL_API")
source("../../R/matt_script.R")

# TopScorer functions
test_that("getTopScorers returns a data frame with the correct number of columns", {
  league <- 39 # Example league ID
  season <- 2020 # Example season
  api_key <- my_key
  
  result <- getTopScorers(league, season, api_key)
  
  # Check if result is a data frame
  expect_true(is.data.frame(result))
  
  # Check for the expected number of columns
  expect_equal(ncol(result), 11) 
})

# Top assists function test
test_that("getTopAssists returns a data frame with the correct number of columns", {
  league <- 39 # Example league ID
  season <- 2020 # Example season
  api_key <- my_key
  
  result <- getTopAssists(league, season, api_key)
  
  # Check if result is a data frame
  expect_true(is.data.frame(result))
  
  # Check for the expected number of columns
  expect_equal(ncol(result), 12) 
})

# Football fixtures test function
test_that("getFootballFixtures returns a data frame with the correct number of columns", {
  league <- 39 # Example league ID
  season <- 2020 # Example season
  api_key <- my_key
  
  result <- getFootballFixtures(league, season, api_key)
  
  # Check if result is a data frame
  expect_true(is.data.frame(result))
  
  # Check for the expected number of columns
  expect_equal(ncol(result), 8) 
})

# Standings test function
test_that("getFootballStandings returns a data frame with the correct number of columns", {
  league <- 39 # Example league ID
  season <- 2020 # Example season
  api_key <- my_key
  
  result <- getFootballStandings(league, season, api_key)
  
  # Check if result is a data frame
  expect_true(is.data.frame(result))
  
  # Check for the expected number of columns
  expect_equal(ncol(result), 13)
})

# Transfers test function
test_that("getTeamTransfers returns the correct data frame structure", {
  team <- 33 # Example team ID
  api_key <- my_key
  
  result <- getTeamTransfers(team, api_key)
  
  # Check if result is a data frame
  expect_true(is.data.frame(result))
  
  # Check if expected columns are present
  # Assuming expected columns based on the description
  expected_columns <- c("date") # Add more expected columns based on actual data
  expect_true(all(expected_columns %in% names(result)))
})
