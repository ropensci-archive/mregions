#' Convert to WKT
#'
#' @export
#' @param x Output from \code{\link{region_geojson}}
#' @param fmt Format string which indicates the number of digits to display after the
#' decimal point when formatting coordinates. Ignored when shp files or objects
#' passed in
#' @param ... Further args passed on to \code{\link[jsonlite]{fromJSON}} only in the event of json
#' passed as a character string. Ignored when shp files or objects
#' passed in
#' @examples \dontrun{
#' res <- region_geojson(key = "MarineRegions:eez_33176")
#' as_wkt(res, fmt = 5)
#'
#' nms <- region_names()
#' res <- region_geojson(key = nms[[1]]$name)
#' as_wkt(res, fmt = 5)
#'
#' # shp files
#' ## path to wkt
#' as_wkt(region_shp(key = "MarineRegions:eez_33176", read = FALSE))
#' ## spatial object to wkt
#' as_wkt(region_shp(key = "MarineRegions:eez_33176", read = TRUE))
#' }
as_wkt <- function(x, fmt = 16, ...) {
  UseMethod("as_wkt")
}

#' @export
as_wkt.mr_geojson <- function(x, fmt = 16, ...) {
  wellknown::geojson2wkt(x$features[[1]]$geometry, fmt = fmt, ...)
}

#' @export
#' @importFrom sp spTransform
as_wkt.SpatialPolygonsDataFrame <- function(x, fmt = 16, ...) {
  check4pkg("rgdal")
  check4pkg("rgeos")
  shp <- .ensureIsLonlat(x)
  rgeos::writeWKT(shp)
}

#' @export
as_wkt.mr_shp_file <- function(x, fmt = 16, ...) {
  check4pkg("rgdal")
  check4pkg("rgeos")
  rgeos::writeWKT(read_shp(x))
}

.ensureIsLonlat <- function(x) {
  check <- .isLonLat(x)
  if (is.na(check)) return(x)  ## do nothing, we don't know
  if (!check) {
    x <- spTransform(x, "+init=EPSG:4326")
  }
  x
}

# stolen from raster::isLonLat
.isLonLat <- function (x)
{
  p4 <-  x@proj4string@projargs
  if (is.na(p4)) {
    return(NA)
  }
  test <- grepl("longlat", p4, fixed = TRUE) | grepl("lonlat", p4, fixed = TRUE)
  test
}