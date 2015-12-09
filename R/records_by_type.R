#' Get Marineregions records by place type
#'
#' @export
#' @param type (character) One place type name. See
#' \code{\link[httr]{place_types}} for place type names
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' res <- records_by_type(type="EEZ")
#' head(res)
#'
#' types <- place_types()
#' records_by_type(types$type[1])
#' records_by_type(types$type[10])
#' }
records_by_type <- function(type, ...) {
  x <- getter(file.path(mr_base(), 'getGazetteerRecordsByType.json', type, ''), ...)
  jsonlite::fromJSON(x)
}
