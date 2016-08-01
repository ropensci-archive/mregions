#' Get Marineregions place types
#'
#' @export
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @return A data.frame with the columns:
#' \itemize{
#'  \item type (character) the place type
#'  \item description (character) description of the place type
#' }
#' @examples \dontrun{
#' res <- mr_place_types()
#' head(res)
#' res$type
#' }
mr_place_types <- function(...) {
  jsonlite::fromJSON(
    getter(
      file.path(mr_base(), 'getGazetteerTypes.json'),
      format = "application/json; charset=UTF-8;",
      ...
    )
  )
}
