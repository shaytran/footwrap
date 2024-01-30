# library(testthat)
#
# # Mock an API key for testing
# mock_api_key <- "your_mock_api_key"
#
# test_that("GetBiggestVenues works correctly", {
#   skip_on_cran()
#   result <- GetBiggestVenues("England", 5, mock_api_key)
#   expect_true(is.ggplot(result)) # Check for plot output
#   expect_equal(length(result$data), 5) # Check for results
# })
#
# test_that("GetCoachInfo returns correct format", {
#   skip_on_cran()
#   result <- GetCoachInfo("team_id", mock_api_key)
#   expect_true(is.data.frame(result)) # Check for data frame out put
#
# })
#
# test_that("CompareTrophies functions as expected", {
#   skip_on_cran()
#   result <- CompareTrophies("player1", "player2", mock_api_key)
#   expect_true(is.ggplot(result))
# })
#
# # Test for invalid country
# test_that("GetBiggestVenues handles invalid country name", {
#   result <- GetBiggestVenues("InvalidCountry", 5, mock_api_key)
#   expect_null(result)
# })
#
#
# # Test for Zero value
# test_that("GetBiggestVenues handles non-positive top value", {
#   result <- GetBiggestVenues("England", 0, mock_api_key)
#   expect_null(result)
# })
#
#
# # Test for invalid team ID
# test_that("GetCoachInfo handles invalid team id", {
#   result <- GetCoachInfo("InvalidTeamID", mock_api_key)
#   expect_null(result)
# })
#
# # Test for invalid player IDs
# test_that("CompareTrophies handles invalid player ids", {
#   result1 <- CompareTrophies("InvalidPlayer1", "player2", mock_api_key)
#   expect_null(result1)
#   result2 <- CompareTrophies("player1", "InvalidPlayer2", mock_api_key)
#   expect_null(result2)
# })





# Load necessary libraries
library(testthat)
library(webmockr)
library(httr)

# Enable webmockr to intercept HTTP requests
webmockr::enable()

# Define mock responses for valid scenarios
webmockr::stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/venues") %>%
  webmockr::to_return(body = "{\"response\": [{\"name\": \"Venue1\", \"capacity\": 50000}, {\"name\": \"Venue2\", \"capacity\": 45000}]}",
                      status = 200)

webmockr::stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/coachs") %>%
  webmockr::to_return(body = "{\"response\": [{\"firstname\": \"John\", \"lastname\": \"Doe\", \"age\": 45}]}",
                      status = 200)

webmockr::stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/trophies") %>%
  webmockr::to_return(body = "{\"response\": [{\"player_id\": \"player1\", \"n_trophy\": 3}, {\"player_id\": \"player2\", \"n_trophy\": 2}]}",
                      status = 200)

# Define mock responses for edge cases
webmockr::stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/venues?country=InvalidCountry") %>%
  webmockr::to_return(status = 404)

webmockr::stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/coachs?team=InvalidTeamID") %>%
  webmockr::to_return(status = 404)

webmockr::stub_request("get", "https://api-football-v1.p.rapidapi.com/v3/trophies?player=InvalidPlayer1") %>%
  webmockr::to_return(status = 404)

# Test cases
test_that("GetBiggestVenues works correctly", {
  skip_on_cran()
  result <- GetBiggestVenues("England", 5, "dummy_api_key")
  expect_true(is.ggplot(result)) # Check for plot output
  expect_equal(length(result$data), 5) # Check for results
})

test_that("GetCoachInfo returns correct format", {
  skip_on_cran()
  result <- GetCoachInfo("team_id", "dummy_api_key")
  expect_true(is.data.frame(result)) # Check for data frame output
})

test_that("CompareTrophies functions as expected", {
  skip_on_cran()
  result <- CompareTrophies("player1", "player2", "dummy_api_key")
  expect_true(is.ggplot(result))
})

# Test for invalid country
test_that("GetBiggestVenues handles invalid country name", {
  result <- GetBiggestVenues("InvalidCountry", 5, "dummy_api_key")
  expect_null(result)
})

# Test for Zero value
test_that("GetBiggestVenues handles non-positive top value", {
  result <- GetBiggestVenues("England", 0, "dummy_api_key")
  expect_null(result)
})

# Test for invalid team ID
test_that("GetCoachInfo handles invalid team id", {
  result <- GetCoachInfo("InvalidTeamID", "dummy_api_key")
  expect_null(result)
})

# Test for invalid player IDs
test_that("CompareTrophies handles invalid player ids", {
  result1 <- CompareTrophies("InvalidPlayer1", "player2", "dummy_api_key")
  expect_null(result1)
  result2 <- CompareTrophies("player1", "InvalidPlayer2", "dummy_api_key")
  expect_null(result2)
})

# Disable webmockr after tests
webmockr::disable()
