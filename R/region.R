#' Get a region shp file
#'
#' @export
#' @param name (character) Region name
#' @param key (character) Region key
#' @param maxFeatures (integer) Number of features
#' @param path (character) path to write shp files to, only used in \code{region_shp}
#' @param overwrite (logical) Overwrite file if already exists. Default: \code{FALSE}
#' @param read (logical) To read in as spatial object. If \code{FALSE} a path
#' given back. if \code{TRUE}, you need the \code{rgdal} package installed.
#' Default: \code{FALSE}
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
#'
#' # shp files
#' ## just get path
#' region_shp(key = "MarineRegions:eez_33176", read = FALSE)
#' ## read shp file into spatial object
#' res <- region_shp(key = "MarineRegions:eez_33176", read = TRUE)
#' library('leaflet')
#' leaflet() %>% addPolygons(data = res)
#' }
region_shp <- function(name = NULL, key = NULL, maxFeatures = 50,
                       path = "~/.mregions", overwrite = TRUE, read = TRUE) {

  args <- make_args('shp', name, key, maxFeatures)
  res <- m_GET(vliz_base(), args, path, overwrite)
  if (read) {
    check4pkg("rgdal")
    rgdal::readOGR(res, rgdal::ogrListLayers(res), verbose = FALSE)
  } else {
    res
  }
}

#' @export
#' @rdname region_shp
region_geojson <- function(name = NULL, key = NULL, maxFeatures = 50, ...) {
  args <- make_args('geojson', name, key, maxFeatures)
  jsonlite::fromJSON(m_GET(vliz_base(), args, ...), FALSE)
}
