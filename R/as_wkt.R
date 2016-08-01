#' Convert data to WKT
#'
#' @export
#' @param x Output from \code{\link{mr_geojson}}, \code{\link{mr_shp}},
#' or a \code{SpatialPolygonsDataFrame}
#' @param fmt (integer) The number of digits to display after the decimal point when
#' formatting coordinates. Ignored when shp files or \code{SpatialPolygonsDataFrame}
#' passed in
#' @param ... Further args passed on to \code{\link[jsonlite]{fromJSON}} only in the
#' event of json passed as a character string. Ignored when shp files or
#' \code{SpatialPolygonsDataFrame} passed in
#'
#' @details WKT, or Well Known Text, is a way to encode spatial data. It's somewhat
#' similar to GeoJSON, but instead of being in JSON format, it's a character string
#' (though can also be encoded in binary format). WKT is often used in SQL databases,
#' and many species occurrence APIs allow only WKT. You could do the conversion to
#' WKT yourself, but we provide \code{as_wkt} as a convenience
#'
#' @return a character string of WKT data
#'
#' @examples \dontrun{
#' res <- mr_geojson(key = "MarineRegions:eez_33176")
#' mr_as_wkt(res, fmt = 5)
#'
#' nms <- mr_names()
#' res <- mr_geojson(key = grep("MarineRegions", nms$name, value = TRUE)[10])
#' mr_as_wkt(res, fmt = 5)
#'
#' # shp files
#' ## path to wkt
#' mr_as_wkt(mr_shp(key = "MarineRegions:eez_33176", read = FALSE))
#'
#' ## spatial object to wkt
#' mr_as_wkt(mr_shp(key = "MarineRegions:eez_33176", read = TRUE))
#' }
mr_as_wkt <- function(x, fmt = 16, ...) {
  UseMethod("mr_as_wkt")
}

#' @export
mr_as_wkt.mr_geojson <- function(x, fmt = 16, ...) {
  wellknown::geojson2wkt(x$features[[1]]$geometry, fmt = fmt, ...)
}

#' @export
#' @importFrom sp spTransform
mr_as_wkt.SpatialPolygonsDataFrame <- function(x, fmt = 16, ...) {
  check4pkg("rgdal")
  check4pkg("rgeos")
  shp <- .ensureIsLonlat(x)
  rgeos::writeWKT(shp)
}

#' @export
mr_as_wkt.mr_shp_file <- function(x, fmt = 16, ...) {
  check4pkg("rgdal")
  check4pkg("rgeos")
  rgeos::writeWKT(read_shp(x))
}

.ensureIsLonlat <- function(x) {
  check <- .isLonLat(x)
  if (is.na(check)) return(x)  ## do nothing, we don't know
  if (!check) {
    x <- sp::spTransform(x, "+init=EPSG:4326")
  }
  x
}

# stolen from raster::isLonLat
.isLonLat <- function(x) {
  p4 <-  x@proj4string@projargs
  if (is.na(p4)) {
    return(NA)
  }
  test <- grepl("longlat", p4, fixed = TRUE) | grepl("lonlat", p4, fixed = TRUE)
  test
}
