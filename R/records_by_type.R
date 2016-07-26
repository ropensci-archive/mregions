#' Get Marineregions records by place type
#'
#' @export
#' @template dframe1
#' @param type (character) One place type name. See \code{\link{place_types}} for
#' place type names
#' @param offset (numeric) Offset to start at. Each request can return up to
#' 100 results. e.g., an offset of 200 will give records 200 to 299.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @details Internally we use the \code{getGazetteerRecordsByType.json} API method,
#' which searches for Marineregions records by user supplied place type
#' @examples \dontrun{
#' res <- records_by_type(type="EEZ")
#' head(res)
#'
#' types <- place_types()
#' records_by_type(types$type[1])
#' records_by_type(types$type[10])
#' records_by_type(grep("MEOW", types$type, value = TRUE))
#' records_by_type(grep("MEOW", types$type, value = TRUE), offset = 100)
#' }
records_by_type <- function(type, offset = 0, ...) {
  stopifnot(is.numeric(offset) || is.integer(offset))
  url <- utils::URLencode(file.path(mr_base(), 'getGazetteerRecordsByType.json', type, offset, '/'))
  x <- getter(url, args = NULL,
    format = "application/json; charset=UTF-8;", ...
  )
  jsonlite::fromJSON(x)
}
