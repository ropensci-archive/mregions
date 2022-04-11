#' Marine regions data from Marineregions
#'
#'Tools to get marine regions data from
#'\url{https://www.marineregions.org/}. Includes tools to get region metadata,
#'as well as data in 'GeoJSON' format, as well as Shape files. Use cases
#'include using data downstream to visualize 'geospatial' data by marine
#'region, mapping variation among different regions, and more.
#'
#' @name mregions-package
#' @aliases mregions
#' @docType package
#' @author Scott Chamberlain
#' @author Francois Michonneau
#' @author Pieter Provoost
#' @author Michael Sumner
#' @author Lennert Schepers
#' @author Salvador Fernandez \email{salvador.fernandez@@vliz.be}
#' @keywords package
#' @details mregions gets data from <https://www.marineregions.org/>
#' @importFrom utils URLencode
#'
#' @section Use-cases:
#' \pkg{mregions} is useful to a wide diversity of R users because you get
#' access to all of the data MarineRegions has, which can help in a
#' variety of use cases:
#'
#' - Visualize marine regions alone
#' - Visualize marine regions with associated data paired with analysis
#' - Use marine region geospatial boundaries to query data providers
#'  (e.g., OBIS (<https://www.obis.org>))
#' - Geocode - get geolocation data from place names
#' - Reverse Geocode - get place names from geolocation data
#'
#' @examples \dontrun{
#' ## GeoJSON
#' ### Get region
#' res <- mr_geojson(key = "Morocco:dam")
#'
#' ### Plot data
#' if (!requireNamespace("leaflet")) {
#'  install.packages("leaflet")
#' }
#' library('leaflet')
#' leaflet() %>%
#'   addProviderTiles(provider = 'OpenStreetMap') %>%
#'   addGeoJSON(geojson = res$features) %>%
#'   setView(-3.98, 35.1, zoom = 11)
#'
#' ## Shape
#' ### Get region
#' res <- mr_shp(key = "MarineRegions:eez_iho_union_v2")
#' library('leaflet')
#' leaflet() %>%
#'   addProviderTiles(provider = 'OpenStreetMap') %>%
#'   addPolygons(data = res)
#'
#' ## Convert to WKT
#' ### From geojson
#' res <- mr_geojson(key = "Morocco:dam")
#' mr_as_wkt(res, fmt = 5)
#'
#' ### From shp object (`SpatialPolygonsDataFrame`) or file, both work
#' mr_as_wkt(mr_shp(key = "Morocco:dam", read = FALSE))
#' ## spatial object to wkt
#' mr_as_wkt(mr_shp(key = "Morocco:dam", read = TRUE))
#' }
NULL
