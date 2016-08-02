#' Marine regions data from Marineregions
#'
#' @name mregions-package
#' @aliases mregions
#' @docType package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
#' @details mregions gets data from <http://www.marineregions.org/>
#'
#' @section Use-cases:
#' \pkg{mregions} is useful to a wide diversity of R users because you get access to
#' all of the data MarineRegions has, which can help in a variety of use cases:
#'
#' \itemize{
#'  \item Visualize marine regions alone
#'  \item Visualize marine regions with associated data paired with analysis
#'  \item Use marine region geospatial boundaries to query data providers (e.g., OBIS (<http://www.iobis.org>))
#'  \item Geocode - get geolocation data from place names
#'  \item Reverse Geocode - get place names from geolocation data
#' }
#'
#' @examples \dontrun{
#' ## GeoJSON
#' ### Get region
#' res <- mr_geojson(name = "Turkmen Exclusive Economic Zone")
#'
#' ### Plot data
#' if (!requireNamespace("leaflet")) {
#'  install.packages("leaflet")
#' }
#' library('leaflet')
#' leaflet() %>%
#'   addProviderTiles(provider = 'OpenStreetMap') %>%
#'   addGeoJSON(geojson = res$features) %>%
#'   setView(53, 40, zoom = 6)
#'
#' ## Shape
#' ### Get region
#' res <- mr_shp(name = "Belgian Exclusive Economic Zone")
#' library('leaflet')
#' leaflet() %>%
#'   addProviderTiles(provider = 'OpenStreetMap') %>%
#'   addPolygons(data = res)
#'
#' ## Convert to WKT
#' ### From geojson
#' res <- mr_geojson(key = "MarineRegions:eez_33176")
#' mr_as_wkt(res, fmt = 5)
#'
#' ### From shp object (`SpatialPolygonsDataFrame`) or file, both work
#' mr_as_wkt(mr_shp(key = "MarineRegions:eez_33176", read = FALSE))
#' ## spatial object to wkt
#' mr_as_wkt(mr_shp(key = "MarineRegions:eez_33176", read = TRUE))
#' }
NULL
