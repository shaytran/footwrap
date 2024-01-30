library(testthat)

# Load the script with the functions 
source("R/shay_script.R")

# Mock an API key for testing
mock_api_key <- "your_mock_api_key"

test_that("GetBiggestVenues works correctly", {
  skip_on_cran()
  result <- GetBiggestVenues("England", 5, mock_api_key)
  expect_true(is.ggplot(result)) # Check for plot output
  expect_equal(length(result$data), 5) # Check for results
})

test_that("GetCoachInfo returns correct format", {
  skip_on_cran()
  result <- GetCoachInfo("team_id", mock_api_key)
  expect_true(is.data.frame(result)) # Check for data frame out put

})

test_that("CompareTrophies functions as expected", {
  skip_on_cran()
  result <- CompareTrophies("player1", "player2", mock_api_key)
  expect_true(is.ggplot(result))
})

# Test for invalid country
test_that("GetBiggestVenues handles invalid country name", {
  result <- GetBiggestVenues("InvalidCountry", 5, mock_api_key)
  expect_null(result)
})


# Test for Zero value
test_that("GetBiggestVenues handles non-positive top value", {
  result <- GetBiggestVenues("England", 0, mock_api_key)
  expect_null(result)
})


# Test for invalid team ID
test_that("GetCoachInfo handles invalid team id", {
  result <- GetCoachInfo("InvalidTeamID", mock_api_key)
  expect_null(result)
})

# Test for invalid player IDs
test_that("CompareTrophies handles invalid player ids", {
  result1 <- CompareTrophies("InvalidPlayer1", "player2", mock_api_key)
  expect_null(result1)
  result2 <- CompareTrophies("player1", "InvalidPlayer2", mock_api_key)
  expect_null(result2)
})
