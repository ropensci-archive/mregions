#' Get a region shp file
#'
#' @export
#' @param x Region name
#' @param format one of geojson, shp
#' @examples \dontrun{
#' res <- region(x = "MarineRegions:eez_33176", format = "geojson")
#'
#' library("geojsonio")
#' as.json(res) %>% map_leaf
#'
#' nms <- region_names()
#' as.json(region(nms[[1]]$name)) %>% map_leaf
#' }
region <- function(x, format = "geojson") {
  format <- match.arg(format, c('geojson', 'shp'))
  args <- list(service = 'WFS', version = '1.0.0', request = 'GetFeature',
               typeName = x, maxFeatures = 50,
               outputFormat = "application/json")
  res <- m_GET(vliz_base(), args)
  jsonlite::fromJSON(res, FALSE)
}
