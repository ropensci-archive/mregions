#' Get Marineregions place types
#'
#' @export
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' place_types()
#' }
place_types <- function(...) {
  jsonlite::fromJSON(getter(file.path(mr_base(), 'getGazetteerTypes.json'), list()))
}
