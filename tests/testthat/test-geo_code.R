context("mr_geo_code")
custom_skip <- function(){
  skip_on_cran()
  skip_if_offline()
}

test_that("mr_geo_code works for like true fuzzy false", {
  custom_skip()

  aa <- mr_geo_code(place = "oost", like = TRUE, fuzzy = FALSE)

  expect_is(aa, "data.frame")
  expect_true(NROW(aa) > 0)
  expect_is(aa$preferredGazetteerName, "character")
  expect_true(class(aa$MRGID) %in% c('numeric', 'integer'))
})

test_that("mr_geo_code works for like true fuzzy true", {
  custom_skip()

  aa <- mr_geo_code(place = "oost", like = TRUE, fuzzy = TRUE)

  expect_is(aa, "data.frame")
  expect_true(NROW(aa) > 0)
  expect_is(aa$preferredGazetteerName, "character")
  expect_true(class(aa$MRGID) %in% c('numeric', 'integer'))
})

test_that("mr_geo_code works for like false fuzzy true", {
  custom_skip()

  aa <- mr_geo_code(place = "oostende", like = FALSE, fuzzy = TRUE)

  expect_is(aa, "data.frame")
  expect_true(length(aa) > 0)
})

test_that("mr_geo_code works for like false fuzzy false", {
  custom_skip()

  aa <- mr_geo_code(place = "oostende", like = FALSE, fuzzy = FALSE)

  expect_is(aa, "data.frame")
  expect_true(length(aa) > 0)
})
