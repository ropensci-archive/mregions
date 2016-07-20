context("wkt projection")


test_that("conversion to wkt results in longlat data", {
  shpfile <- region_shp(key = "MarineRegions:eez_33176", read = FALSE)
  x <- rgdal::readOGR(dirname(shpfile), gsub("\\.shp", "", basename(shpfile)), verbose = FALSE)
  x1 <- sp::spTransform(x, "+proj=laea +ellps=WGS84 +lon_0=2.5 +lat_0=51.6")
  wkt <- as_wkt(x1)
  ## should not see a number like this
  expect_that(length(grep("-441", wkt)), equals(0L))
})

