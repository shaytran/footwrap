library(testthat)

# Setting the API key from environment variable
my_key <- Sys.getenv("FOOTBALL_API")

# Test for venue function
test_that("GetBiggestVenues returns the correct structure", {
  api_key <- my_key
  country_name <- "Brazil"
  top_venues <- 5 # Example number

  result <- GetBiggestVenues(country_name, top_venues, api_key)

  # Expect that the result is a ggplot object
  expect_true(is.ggplot(result))

})

# Test for Coach function
test_that("GetCoachInfo successfully returns a gt table", {
  api_key <- my_key
  team_id <- "40" # Example team ID for testing

  result <- GetCoachInfo(team_id, api_key)

  # Check that the result is of the correct class for a gt table
  expect_true(inherits(result, "gt_tbl"))
})

# Test for trophy function
test_that("CompareTrophies generates a plot", {
  api_key <- my_key
  player_id_1 <- "276" # Example player ID for testing
  player_id_2 <- "260"

  result <- CompareTrophies(player_id_1, player_id_2, api_key)

  # Expect that the result is a ggplot object
  expect_true(is.ggplot(result))
})
