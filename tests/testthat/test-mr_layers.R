context("mr_layers")

test_that("mr_layers works ", {
  skip_on_cran()

  res <- mr_layers()

  expect_is(res, "list")
  expect_gt(length(res), 0)
  expect_equal(unique(sapply(res, function(z) length(names(z)))), c(11, 12))
  expect_is(res[[1]]$Title, "character")
})

test_that("mr_layers fails well", {
  skip_on_cran()

  expect_error(mr_layers("stuff"), "no applicable method")
})
