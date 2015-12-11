#' Get a Marineregions geojson file
#'
#' @export
#' @param name (character) Region name
#' @param key (character) Region key
#' @param maxFeatures (integer) Number of features
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # by key
#' res <- region_geojson(key = "MarineRegions:eez_33176")
#'
#' # by name
#' res <- region_geojson(name = "Turkmen Exclusive Economic Zone")
#'
#' library("geojsonio")
#' as.json(res) %>% map_leaf
#'
#' nms <- region_names()
#' as.json(region_geojson(nms[[1]]$name)) %>% map_leaf
#' }
region_geojson <- function(name = NULL, key = NULL, maxFeatures = 50, ...) {
  args <- make_args('geojson', name, key, maxFeatures)
  structure(jsonlite::fromJSON(m_GET(vliz_base(), args, ...), FALSE), class = "mr_geojson")
}
