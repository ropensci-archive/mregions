#' Get a Marineregions geojson file
#'
#' @export
#' @param key (character) Region key, of the form \code{x:y}, where
#' \code{x} is a namespace (e.g., \code{MarineRegions}), and \code{y} is
#' a region (e.g., \code{eez_33176})
#' @param name (character) Region name, if you supply this, we search
#' against titles via \code{\link{region_names}} function
#' @param maxFeatures (integer) Number of features to return. Default: \code{50}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @return an S3 class of type \code{mr_geojson}, just a thin wrapper around
#' a list
#' @examples \dontrun{
#' # by key
#' res <- region_geojson(key = "MarineRegions:eez_33176")
#'
#' # by name
#' res <- region_geojson(name = "Turkmen Exclusive Economic Zone")
#'
#' if (requireNamespace("geojsonio")) {
#'   library("geojsonio")
#'   as.json(res) %>% map_leaf
#'
#'   nms <- region_names()
#'   as.json(unclass(region_geojson(nms[[40]]$name))) %>% map_leaf()
#'
#'   # MEOW - marine ecoregions
#'   as.json(unclass(region_geojson("Ecoregions:ecoregions"))) %>% map_leaf()
#' }
#' }
region_geojson <- function(key = NULL, name = NULL, maxFeatures = 50, ...) {
  args <- make_args('geojson', name, key, maxFeatures)
  key <- nameorkey(name, key)
  structure(jsonlite::fromJSON(
    m_GET(sub("ows", file.path(strsplit(key, ":")[[1]][1], "ows"), vliz_base()), args,
          format = "application/json", ...), FALSE), class = "mr_geojson")
}
