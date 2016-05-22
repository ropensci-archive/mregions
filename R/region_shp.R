#' Get a region shp file
#'
#' @export
#' @param key (character) Region key, of the form \code{x:y}, where
#' \code{x} is a namespace (e.g., \code{MarineRegions}), and \code{y} is
#' a region (e.g., \code{eez_33176})
#' @param name (character) Region name, if you supply this, we search
#' against titles via \code{\link{region_names}} function
#' @param maxFeatures (integer) Number of features
#' @param overwrite (logical) Overwrite file if already exists. Default: \code{FALSE}
#' @param read (logical) To read in as spatial object. If \code{FALSE} a path
#' given back. if \code{TRUE}, you need the \code{rgdal} package installed.
#' Default: \code{FALSE}
#' @param filter (character) String to filter features on
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @return A \code{SpatialPolygonsDataFrame}
#' @details We use \pkg{rappdirs} to determine where to cache data depening on
#' your operating system. See \code{rappdirs::user_cache_dir("mregions")} for
#' location on your machine
#' @examples \dontrun{
#' ## just get path
#' region_shp(key = "MarineRegions:eez_33176", read = FALSE)
#' ## read shp file into spatial object
#' res <- region_shp(key = "MarineRegions:eez_33176", read = TRUE)
#'
#' region_shp(key = "SAIL:w_marinehabitatd")
#'
#' if (requireNamespace("leaflet")) {
#'   library('leaflet')
#'   leaflet() %>%
#'     addProviderTiles(provider = "Stamen.TonerHybrid") %>%
#'     addPolygons(data = res)
#' }
#'
#' # use `filter` param to get a subset of a region
#' region_shp(name="World Marine Heritage Sites", maxFeatures=NULL,
#'   filter="iSimangaliso Wetland Park")
#' }
region_shp <- function(key = NULL, name = NULL, maxFeatures = 50,
                       overwrite = TRUE, read = TRUE, filter = NULL, ...) {

  cache_dir <- rappdirs::user_cache_dir("mregions")
  if (!file.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)

  args <- make_args('shp', name, key, maxFeatures)
  key <- nameorkey(name, key)

  file <- file.path(cache_dir, paste0(sub(":", "_", args$typeName), ".zip"))
  if (!file.exists(sub("\\.zip", "", file))) {
    res <- m_GET(sub("ows", file.path(strsplit(key, ":")[[1]][1], "ows"), vliz_base()),
                 args, file, overwrite, ...)
  } else {
    res <- path.expand(list.files(sub("\\.zip", "", file), pattern = ".shp", full.names = TRUE))
  }

  if (read) {
    check4pkg("rgdal")
    shp <- read_shp(res)
    if (!is.null(filter)) {
      shp[which(rowSums(shp@data == filter, na.rm = TRUE) > 0),]
    } else {
      shp
    }
  } else {
    structure(res, class = 'mr_shp_file')
  }
}

read_shp <- function(x) {
  rgdal::readOGR(x, rgdal::ogrListLayers(x), verbose = FALSE)
}
