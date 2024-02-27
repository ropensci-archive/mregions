context("mr_features_get")

test_that("mr_features_get - json", {
  skip_on_cran()
  aa <- mr_features_get(type = "MarineRegions:eez", featureID = "eez.3")
  expect_is(aa, "character")
  expect_match(aa, "FeatureCollection")
})

test_that("mr_features_get - KML", {
  skip_on_cran()
  aa <- mr_features_get(type = "MarineRegions:eez", featureID = "eez.3", format = "KML")
  expect_is(aa, "character")
  expect_is(xml2::read_xml(aa), "xml_document")
})

# FIXME - shape files not working right now
test_that("mr_features_get - zip", {
  skip_on_cran()
  file <- tempfile(fileext = ".zip")
  tdir <- tempdir()
  aa <- mr_features_get(type = "MarineRegions:eez", featureID = "eez.3", format = "SHAPE-ZIP", path = file)
  expect_is(aa, "character")
  expect_true(file.exists(file))

  unzip(aa, exdir = tdir)
  lfiles <- list.files(tdir)

  expect_true(any(grepl("eez", lfiles)))

  # cleanup
  unlink(file)
})

test_that("mr_features_get - gml32", {
  skip_on_cran()
  aa <- mr_features_get(type = "MarineRegions:eez", featureID = "eez.3",
                        format = "gml32")
  expect_is(aa, "character")
  expect_is(xml2::read_xml(aa), "xml_document")
})

test_that("mr_features_get - version parameter works", {
  skip_on_cran()

  aa <- mr_features_get(type = "MarineRegions:eez", featureID = "eez.3")

  expect_is(aa, "character")

  # the coordinates are reversed in the two versions
  expect_match(strext(aa, "-?[0-9]{2,}"), "-159")
})

test_that("mr_features_get fails well", {
  skip_on_cran()

  expect_error(mr_features_get(),
               "argument \"type\" is missing")
})
