context("place_relations")

test_that("place_relations works", {
    skip_on_cran()
    res <- place_relations(18550)
    expect_is(res, "data.frame")
    expect_true(NROW(res) > 0)
    expect_is(res$preferredGazetteerName, "character")
    expect_true(class(res$MRGID) %in% c("numeric", "integer"))
})
