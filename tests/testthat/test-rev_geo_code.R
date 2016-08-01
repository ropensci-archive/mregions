context("mr_rev_geo_code")

test_that("mr_rev_geo_code fails if input is not numeric", {
    skip_on_cran()
    expect_error(expect_warning(mr_rev_geo_code("test", -10)))
    expect_error(mr_rev_geo_code("", -10))
    expect_error(mr_rev_geo_code(10, TRUE))
    expect_error(mr_rev_geo_code(10, 10, NA))
})


test_that("mr_rev_geo_code works ", {
    skip_on_cran()

    res <- mr_rev_geo_code(-21.5, 55.5, lat_radius = .5, lon_radius = .5)

    expect_is(res, "data.frame")
    expect_true(NROW(res) > 0)
    expect_true(class(res$MRGID) %in%  c("integer", "numeric"))
    expect_is(res$preferredGazetteerName, "character")
})
