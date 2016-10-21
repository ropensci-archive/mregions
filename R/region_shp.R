#' Get a region shp file
#'
#' @export
#' @param key (character) Region key, of the form \code{x:y}, where
#' \code{x} is a namespace (e.g., \code{MarineRegions}), and \code{y} is
#' a region (e.g., \code{eez_33176})
#' @param name (character) Region name, if you supply this, we search
#' against titles via \code{\link{mr_names}} function
#' @param maxFeatures (integer) Number of features
#' @param overwrite (logical) Overwrite file if already exists. Default: \code{FALSE}
#' @param read (logical) To read in as spatial object. If \code{FALSE} a path
#' given back. if \code{TRUE}, you need the \code{rgdal} package installed.
#' Default: \code{FALSE}
#' @param filter (character) String to filter features on
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#'
#' @return A \code{SpatialPolygonsDataFrame} if \code{read = TRUE}, or a path to
#' a SHP file on disk if \code{read = FALSE}.
#'
#' @details We use \pkg{rappdirs} to determine where to cache data depening on
#' your operating system. See \code{rappdirs::user_cache_dir("mregions")} for
#' location on your machine
#'
#' We cache based on the name of the region plus the \code{maxFeatures} parameter.
#' That is to say, you can query the same region name, but with different
#' \code{maxFeatures} parameter values, and they will get cached separately.
#' You can clear the cache by going to the directory at
#' \code{rappdirs::user_cache_dir("mregions")} and deleting the files.
#'
#' We use \code{stringsAsFactors = FALSE} inside of \code{rgdal::readOGR()}
#' so that character variables aren't converted to factors.
#'
#' @examples \dontrun{
#' ## just get path
#' mr_shp(key = "MarineRegions:eez_iho_union_v2", read = FALSE)
#' ## read shp file into spatial object
#' res <- mr_shp(key = "MarineRegions:eez_iho_union_v2", read = TRUE)
#'
#' mr_shp(key = "SAIL:w_marinehabitatd")
#'
#' if (requireNamespace("leaflet")) {
#'   library('leaflet')
#'   leaflet() %>%
#'     addProviderTiles(provider = "Stamen.TonerHybrid") %>%
#'     addPolygons(data = res)
#' }
#'
#' # use `filter` param to get a subset of a region
#' mr_shp(name="World Marine Heritage Sites", maxFeatures=NULL,
#'   filter="iSimangaliso Wetland Park")
#' }
mr_shp <- function(key = NULL, name = NULL, maxFeatures = 50,
                       overwrite = TRUE, read = TRUE, filter = NULL, ...) {

  cache_dir <- rappdirs::user_cache_dir("mregions")
  if (!file.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)

  args <- make_args('shp', name, key, maxFeatures)
  key <- nameorkey(name, key)

  file <- file.path(
    cache_dir,
    paste0(
      sub(":", "_", args$typeName),
      "_maxfeatures",
      if (is.null(args$maxFeatures)) "null" else args$maxFeatures,
      ".zip"
    )
  )
  if (!file.exists(sub("\\.zip", "", file))) {
    res <- m_GET(url=sub("ows", file.path(strsplit(key, ":")[[1]][1], "ows"), vliz_base()),
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
  rgdal::readOGR(x, rgdal::ogrListLayers(x), verbose = FALSE, stringsAsFactors = FALSE)
}
