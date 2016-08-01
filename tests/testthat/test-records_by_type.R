context("mr_records_by_type")

test_that("mr_records_by_type works for EEZ", {
  skip_on_cran()

  aa <- mr_records_by_type(type = "EEZ")

  expect_is(aa, "data.frame")
  expect_gt(NROW(aa), 0)
  expect_is(aa$preferredGazetteerName, "character")
  expect_true(all(grepl("Exclusive Economic Zone", aa$preferredGazetteerName, ignore.case = TRUE)))
})

test_that("mr_records_by_type works for other types", {
  skip_on_cran()

  types <- mr_place_types()

  expect_is(types, "data.frame")

  aa <- mr_records_by_type(type = types$type[1])

  expect_is(aa, "data.frame")
  expect_true(NROW(aa) > 0)
  expect_match(aa$placeType, "Town")
})

test_that("mr_records_by_type offset parameter works", {
  skip_on_cran()

  types <- mr_place_types()

  aa <- mr_records_by_type(type = types$type[1], offset = 0)
  bb <- mr_records_by_type(type = types$type[1], offset = 5)

  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_equivalent(aa[6,], bb[1,])
})

test_that("mr_records_by_type fails well", {
  skip_on_cran()

  expect_error(mr_records_by_type(),
               "argument \"type\" is missing")

  expect_error(mr_records_by_type("town", offset = "asdf"),
               "is not TRUE")

  expect_equal(mr_records_by_type("adfadsf"),
               list())
})
