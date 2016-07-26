#' Geocode with Marineregions
#'
#' @export
#' @param place (character) a place name
#' @param like (logical) adds a percent-sign before and after place value
#' (a SQL LIKE function). Default: \code{TRUE}
#' @param fuzzy (logical) Uses Levenshtein query to find nearest matches.
#' Default: \code{FALSE}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' geo_code(place = "oost", like = TRUE, fuzzy = FALSE)
#' geo_code(place = "oost", like = FALSE, fuzzy = FALSE)
#' geo_code(place = "oost", like = FALSE, fuzzy = TRUE)
#' geo_code(place = "oost", like = TRUE, fuzzy = TRUE)
#' }
geo_code <- function(place, like = TRUE, fuzzy = FALSE, ...) {
  base <- file.path(mr_base(), "getGazetteerRecordsByName.json/%s/%s/%s")
  url <- sprintf(base, place, conv_log(like), conv_log(fuzzy))
  res <- httr::GET(url, ...)
  httr::stop_for_status(res)
  jsonlite::fromJSON(contutf8(res), flatten = TRUE)
}

conv_log <- function(x) {
  if (inherits(x, "logical")) {
    tolower(x)
  } else {
    ''
  }
}
