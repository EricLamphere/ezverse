context("test-utils.R")

test_that("ezverse packages returns character vector of package names", {
  out <- ezverse_packages()
  expect_type(out, "character")
  expect_true("ezxfig" %in% out)
})
