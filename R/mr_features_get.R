#' Get features
#'
#' @export
#' @param type (character) a region type, e.g., "MarineRegions:eez". required
#' @param featureID (character) a feature ID. required
#' @param maxFeatures (integer) Number of features. Default: 100
#' @param format (character) output format, see Details for allowed options.
#' Default: json
#' @param path (character) required when \code{format="SHAPE-ZIP"},
#' otherwise, ignored
#' @param version (character) either 1.0.0 or 2.0.0 (default). In v1.0.0, the
#' coordinates are in format y,x (long,lat), while in 2.0.0 the coordinates
#' are in format x,y (lat,long)
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#'
#' @return depends on the \code{format} option used, usually a text string
#'
#' @details Allowed options for the \code{format} parameter:
#' \itemize{
#'  \item \code{text/xml; subtype=gml/3.2}
#'  \item \code{GML2}
#'  \item \code{KML}
#'  \item \code{SHAPE-ZIP}
#'  \item \code{application/gml+xml; version=3.2}
#'  \item \code{application/json}
#'  \item \code{application/vnd.google-earth.kml xml}
#'  \item \code{application/vnd.google-earth.kml+xml}
#'  \item \code{csv}
#'  \item \code{gml3}
#'  \item \code{gml32}
#'  \item \code{json}
#'  \item \code{text/xml; subtype=gml/2.1.2}
#'  \item \code{text/xml; subtype=gml/3.1.1}
#' }
#'
#' @examples \dontrun{
#' # json by default
#' mr_features_get(type = "MarineRegions:eez", featureID = "eez.3")
#' # csv
#' mr_features_get(type = "MarineRegions:eez", featureID = "eez.3",
#'   format = "csv")
#' # KML
#' mr_features_get(type = "MarineRegions:eez", featureID = "eez.3",
#'   format = "KML")
#'
#' # if you want SHAPE-ZIP, give a file path
#' # FIXME - shape files not working right now
#' # file <- tempfile(fileext = ".zip")
#' # mr_features_get(type = "MarineRegions:eez", featureID = "eez.3",
#' #   format = "SHAPE-ZIP", path = file)
#' # file.exists(file)
#' # unlink(file)
#'
#' # glm32
#' mr_features_get(type = "MarineRegions:eez", featureID = "eez.3",
#'   format = "gml32")
#'
#' # version parameter
#' ## notice the reversed coordinates
#' mr_features_get(type = "MarineRegions:eez", featureID = "eez.3")
#' mr_features_get(type = "MarineRegions:eez", featureID = "eez.3",
#'   version = "1.0.0")
#' }
mr_features_get <- function(type, featureID, maxFeatures = 100,
                            format = "json", path = NULL, version = "2.0.0",
                            ...) {

  if (!format %in% names(mime_map)) {
    stop("format ", format, " not in acceptable set, see help file",
         call. = FALSE)
  }
  if (format %in% c('SHAPE-ZIP') && is.null(path)) {
    stop("if you specify 'SHAPE-ZIP' format, you must give a file path",
         call. = FALSE)
  }
  if (!version %in% c('1.0.0', '2.0.0')) {
    stop("version must be one of '1.0.0' or '2.0.0'",
         call. = FALSE)
  }
  args <- list(typeNames = type, maxFeatures = maxFeatures,
               featureID = featureID, service = 'wfs',
               request = 'GetFeature', version = version,
               outputFormat = format)
  getter2(url = "http://geo.vliz.be/geoserver/MarineRegions/wfs",
         args, format = mime_map[[format]], path = path, ...)
}

mime_map <- list(
  `text/xml; subtype=gml/3.2` = 'text/xml; subtype=gml/3.2',
  `GML2` = 'text/xml; subtype=gml/2.1.2',
  `KML` = 'application/vnd.google-earth.kml+xml',
  `SHAPE-ZIP` = 'application/zip',
  `application/gml+xml; version=3.2` = 'text/xml; subtype=gml/3.2',
  `application/json` = 'application/json',
  `application/vnd.google-earth.kml xml` = 'application/vnd.google-earth.kml+xml',
  `application/vnd.google-earth.kml+xml` = 'application/vnd.google-earth.kml+xml',
  `csv` = 'text/csv;charset=UTF-8',
  `gml3` = 'application/xml',
  `gml32` = 'text/xml; subtype=gml/3.2',
  `json` = "application/json;charset=UTF-8",
  `text/xml; subtype=gml/2.1.2` = 'text/xml; subtype=gml/2.1.2',
  `text/xml; subtype=gml/3.1.1` = 'application/xml'
)
