#' Get OBIS EEZ id
#'
#' @export
#' @param x Output from \code{\link{region_geojson}}
#' @examples \dontrun{
#' (res <- region_names())
#' obis_eez_id(x = res[[1]]$title)
#' }
obis_eez_id <- function(x) {
  eezs <- obis_eez()
  eezs[eezs$name %in% x, "id"]
}

obis_eez <- function() {
  rs <- getter(file.path(obis_base(), "eez"))
  jsonlite::fromJSON(rs)$results
}

obis_base <- function() "http://api.iobis.org"
