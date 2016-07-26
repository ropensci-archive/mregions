##' Retrieve the names of geographic objects from coordinates (and
##' optionally a radius around them).
##'
##' @export
##' @template dframe1
##' @title Reverse Geocode with Marineregions
##' @param lat (numeric) Latitude for the coordinates (decimal format)
##' @param lon (numeric) Longitude for the coordinates (decimal format)
##' @param lat_radius (numeric) Extends search to include the range from
##'     \code{lat}-\code{lat_radius} to \code{lat}+\code{lat_radius}
##' @param lon_radius (numeric) Extends search to include the range from
##'     \code{lon}-\code{lon_radius} to \code{lon}+\code{lon_radius}
##' @param ... curl options to be passed on to \code{\link[httr]{GET}}
##' @examples \dontrun{
##' rev_geo_code(-21.5, 55.5, lat_radius=.5, lon_radius=.5)
##' rev_geo_code(-21.5, 55.5, lat_radius=3, lon_radius=3)
##' rev_geo_code(-15, 45, lat_radius=1, lon_radius=1)
##' }
##' @author Francois Michonneau <francois.michonneau@gmail.com>
rev_geo_code <- function(lat, lon, lat_radius = 1, lon_radius = 1, ...) {
  sapply(list(lat, lon, lat_radius, lon_radius), check_is_number)
  base <- paste0(mr_base(), "/getGazetteerRecordsByLatLong.json/%s/%s/%s/%s")
  url <- sprintf(base, lat, lon, lat_radius, lon_radius)
  res <- httr::GET(url, ...)
  httr::stop_for_status(res)
  jsonlite::fromJSON(contutf8(res), flatten = TRUE)
}

check_is_number <- function(x) {
  msg <- paste(x, "is not a number")
  if (is.logical(x)) {
    stop(msg, call. = FALSE)
  }
  x <- as.numeric(x)
  if (!(is.numeric(x) && length(x) == 1
        && !is.na(x)))
    stop(msg, call. = FALSE)
}
