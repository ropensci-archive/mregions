context("mr_names")

test_that("mr_names basic functionality works", {
  skip_on_cran()

  aa <- mr_names('MarineRegions:iho')

  expect_is(aa, "data.frame")
  expect_is(aa, "tbl_df")
  expect_is(aa$layer, "character")
  expect_is(aa$id, "character")

  expect_match(aa$layer, "MarineRegions:iho")
  expect_match(aa$id, "iho")

  expect_gt(NROW(aa), 10)
})

test_that("mr_names works for fao data source", {
  skip_on_cran()

  aa <- mr_names('MarineRegions:fao')

  expect_is(aa, "data.frame")
  expect_is(aa, "tbl_df")
  expect_is(aa$layer, "character")
  expect_is(aa$id, "character")

  expect_match(aa$layer, "MarineRegions:fao")
  expect_match(aa$id, "fao")
})

test_that("mr_names fails well", {
  skip_on_cran()

  expect_error(mr_names('MarineRegions:asdfadf'),
               "Region not found")
})
