##' Retrieve the names of geographic objects from coordinates (and
##' optionally a radius around them).
##'
##' @export
##' @template dframe1
##' @title Reverse Geocode with Marineregions
##' @param lat (numeric) Latitude for the coordinates (decimal format)
##' @param lon (numeric) Longitude for the coordinates (decimal format)
##' @param lat_radius (numeric) Extends search to include the range from
##'     `lat`-`lat_radius` to `lat`+`lat_radius`
##' @param lon_radius (numeric) Extends search to include the range from
##'     `lon`-`lon_radius` to `lon`+`lon_radius`
##' @param ... curl options to be passed on to [httr::GET()]
##' @examples \dontrun{
##' # Setting radius to 0.5
##' mr_rev_geo_code(-21.5, 55.5, lat_radius=0.5, lon_radius=0.5)
##'
##' # radius to 3
##' mr_rev_geo_code(-21.5, 55.5, lat_radius=3, lon_radius=3)
##'
##' # radius to 1
##' mr_rev_geo_code(-15, 45, lat_radius=1, lon_radius=1)
##' }
##' @author Francois Michonneau <francois.michonneau@gmail.com>
mr_rev_geo_code <- function(lat, lon, lat_radius = 1, lon_radius = 1, ...) {
  invisible(lapply(list(lat, lon, lat_radius, lon_radius), check_is_number))
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
  x <- suppressWarnings(as.numeric(x))
  if (!(is.numeric(x) && length(x) == 1
        && !is.na(x)))
    stop(msg, call. = FALSE)
}
