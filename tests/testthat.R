# tests/testthat.R
library(testthat)

# Load your scripts. This assumes your scripts do not have namespace issues
# and can be directly sourced into the environment.
source("../R/shay_script.R")
# Repeat the source() call for each script you need to load.

# Run the tests
test_dir("testthat", reporter = "summary")