#' Get a Marineregions geojson file
#'
#' @export
#' @param key (character) Region key, of the form \code{x:y}, where
#' \code{x} is a namespace (e.g., \code{MarineRegions}), and \code{y} is
#' a region (e.g., \code{eez_33176})
#' @param name (character) Region name, if you supply this, we search
#' against titles via \code{\link{mr_names}} function
#' @param maxFeatures (integer) Number of features to return. Default: \code{50}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @return an S3 class of type \code{mr_geojson}, just a thin wrapper around
#' a list. The list has names:
#'
#' \itemize{
#'  \item type (character) - the geojson type (e.g., FeatureCollection)
#'  \item totalFeatures (integer) - the
#'  \item features (list) - the features, with slots for each feature: type,
#'  id, geometry, geometry_name, and properties
#'  \item crs (list) - the coordinate reference system
#'  \item bbox (list) - the bounding box that encapsulates the object
#' }
#' @examples \dontrun{
#' # by key
#' res1 <- mr_geojson(key = "Morocco:dam")
#'
#' # by name
#' res2 <- mr_geojson(name = "Ramsar sites in Flanders")
#'
#' if (requireNamespace("geojsonio")) {
#'   library("geojsonio")
#'   as.json(unclass(res2)) %>% map_leaf
#'
#'   nms <- mr_names()
#'   as.json(unclass(mr_geojson(nms$name[40]))) %>% map_leaf()
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
          format = "application/json", ...), FALSE), class = "mr_geojson")
}
