context("mr_geo_code")

test_that("mr_geo_code works for like true fuzzy false", {
  skip_on_cran()

  aa <- mr_geo_code(place = "oost", like = TRUE, fuzzy = FALSE)

  expect_is(aa, "data.frame")
  expect_true(NROW(aa) > 0)
  expect_is(aa$preferredGazetteerName, "character")
  expect_true(class(aa$MRGID) %in% c('numeric', 'integer'))
})

test_that("mr_geo_code works for like true fuzzy true", {
  skip_on_cran()

  aa <- mr_geo_code(place = "oost", like = TRUE, fuzzy = TRUE)

  expect_is(aa, "data.frame")
  expect_true(NROW(aa) > 0)
  expect_is(aa$preferredGazetteerName, "character")
  expect_true(class(aa$MRGID) %in% c('numeric', 'integer'))
})

test_that("mr_geo_code works for like false fuzzy true", {
  skip_on_cran()

  aa <- mr_geo_code(place = "oost", like = FALSE, fuzzy = TRUE)

  expect_is(aa, "list")
  expect_equal(length(aa), 0)
})

test_that("mr_geo_code works for like false fuzzy false", {
  skip_on_cran()

  aa <- mr_geo_code(place = "oost", like = FALSE, fuzzy = FALSE)

  expect_is(aa, "list")
  expect_equal(length(aa), 0)
})
