#' Get a region shp file
#'
#' @export
#' @param name (character) Region name
#' @param key (character) Region key
#' @param format (character) One of 'geojson' or 'shp'
#' @examples \dontrun{
#' # by key
#' res <- region(key = "MarineRegions:eez_33176", format = "geojson")
#'
#' # by name
#' res <- region(name = "Turkmen Exclusive Economic Zone", format = "geojson")
#'
#' library("geojsonio")
#' as.json(res) %>% map_leaf
#'
#' nms <- region_names()
#' as.json(region(nms[[1]]$name)) %>% map_leaf
#' }
region <- function(name = NULL, key = NULL, format = "geojson") {
  format <- match.arg(format, c('geojson', 'shp'))
  key <- nameorkey(name, key)
  args <- list(service = 'WFS', version = '1.0.0', request = 'GetFeature',
               typeName = key, maxFeatures = 50, outputFormat = "application/json")
  res <- m_GET(vliz_base(), args)
  jsonlite::fromJSON(res, FALSE)
}

nameorkey <- function(name, key) {
  stopifnot(xor(!is.null(name), !is.null(key)))
  if (is.null(key)) {
    nms <- region_names()
    nms[vapply(nms, "[[", "", "title") == name][[1]]$name
  } else {
    key
  }
}
