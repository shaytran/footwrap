library(testthat)
library(footwrap)

# Test Cases
test_that("GetBiggestVenues returns correct ggplot object", {
  result <- GetBiggestVenues("England", 5, "mock_api_key")
  expect_is(result, "ggplot")
})

test_that("GetCoachInfo returns correct data frame", {
  result <- GetCoachInfo("team_id_example", "mock_api_key")
  expect_is(result, "data.frame")
  expect_equal(ncol(result), 8) # Check for 8 columns
})

test_that("CompareTrophies returns correct ggplot object", {
  result <- CompareTrophies("player1_id", "player2_id", "mock_api_key")
  expect_is(result, "ggplot")
})
