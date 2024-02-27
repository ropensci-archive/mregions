context("wkt projection")

test_that("conversion to wkt results in longlat data", {
  skip_on_cran()

  shpfile <- mr_shp(key = "MarineRegions:eez_iho_union_v2", read = FALSE)
  x <- read_sf(shpfile)
  x1 <- sf::st_transform(x, "+proj=laea +ellps=WGS84 +lon_0=2.5 +lat_0=51.6")
  x2 <- sf::as_Spatial(x1)
  wkt <- mr_as_wkt(x2)
  expect_match(wkt, 'MULTIPOLYGON')
  expect_match(wkt, 'POLYGON')
})
