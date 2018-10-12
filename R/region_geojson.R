#' Get a Marineregions geojson file
#'
#' @export
#' @param key (character) Region key, of the form `x:y`, where
#' `x` is a namespace (e.g., `MarineRegions`), and `y` is
#' a region (e.g., `eez_33176`)
#' @param name (character) Region name, if you supply this, we search
#' against titles via [mr_names()] function
#' @param maxFeatures (integer) Number of features to return. Default: `50`
#' @param ... Curl options passed on to [httr::GET()]
#' @return an S3 class of type `mr_geojson`, just a thin wrapper around
#' a list. The list has names:
#'
#' - type (character) - the geojson type (e.g., FeatureCollection)
#' - totalFeatures (integer) - the
#' - features (list) - the features, with slots for each feature: type,
#'  id, geometry, geometry_name, and properties
#' - crs (list) - the coordinate reference system
#' - bbox (list) - the bounding box that encapsulates the object
#'
#' @examples \dontrun{
#' # by key
#' res1 <- mr_geojson(key = "Morocco:dam")
#'
#' # by name -- not working right now
#'
#' if (requireNamespace("geojsonio")) {
#'   library("geojsonio")
#'   as.json(unclass(res1)) %>% map_leaf
#'
#'   # MEOW - marine ecoregions
#'   as.json(unclass(mr_geojson("Ecoregions:ecoregions"))) %>% map_leaf()
#' }
#' }
mr_geojson <- function(key = NULL, name = NULL, maxFeatures = 50, ...) {
  args <- make_args('geojson', name, key, maxFeatures)
  key <- nameorkey(name, key)
  structure(jsonlite::fromJSON(
    m_GET(sub("ows", file.path(strsplit(key, ":")[[1]][1], "ows"), vliz_base()), args,
          format = "application/json;charset=UTF-8", ...), FALSE), class = "mr_geojson")
}
