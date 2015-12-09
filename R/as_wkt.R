#' Convert to WKT
#'
#' @export
#' @param x Output from \code{\link{region_geojson}}
#' @param fmt Format string which indicates the number of digits to display after the
#' decimal point when formatting coordinates.
#' @param ... Further args passed on to \code{\link[jsonlite]{fromJSON}} only in the event of json
#' passed as a character string.
#' @examples \dontrun{
#' res <- region_geojson(key = "MarineRegions:eez_33176")
#' as_wkt(res, fmt = 5)
#'
#' nms <- region_names()
#' res <- region_geojson(key = nms[[1]]$name)
#' as_wkt(res, fmt = 5)
#' }
as_wkt <- function(x, fmt = 16, ...) {
  wellknown::geojson2wkt(x$features[[1]]$geometry, fmt = fmt, ...)
}

# nms <- nms[1:25]
# out <- list()
# for (i in seq_along(nms)) {
#   cat(nms[[i]]$name, sep = "\n")
#   tmp <- region_geojson(key = nms[[i]]$name)
#   cat(length(tmp$features), sep = "\n")
#   cat(length(tmp$features[[1]]$geometry), sep = "\n")
#   # out[[i]] <- as_wkt(region_geojson(key = nms[[i]]$name))
# }
#
# wellknown::wktview(out[[9]])
