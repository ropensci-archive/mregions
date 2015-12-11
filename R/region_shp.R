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
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' ## just get path
#' region_shp(key = "MarineRegions:eez_33176", read = FALSE)
#' ## read shp file into spatial object
#' res <- region_shp(key = "MarineRegions:eez_33176", read = TRUE)
#' library('leaflet')
#' leaflet() %>% addPolygons(data = res)
#' }
region_shp <- function(name = NULL, key = NULL, maxFeatures = 50,
  path = "~/.mregions", overwrite = TRUE, read = TRUE, ...) {

  args <- make_args('shp', name, key, maxFeatures)
  res <- m_GET(vliz_base(), args, path, overwrite, ...)
  if (read) {
    check4pkg("rgdal")
    read_shp(res)
  } else {
    structure(res, class = 'mr_shp_file')
  }
}

read_shp <- function(x) {
  rgdal::readOGR(x, rgdal::ogrListLayers(x), verbose = FALSE)
}
