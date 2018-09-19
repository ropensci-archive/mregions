#' Geocode with Marineregions
#'
#' @export
#' @template dframe1
#' @param place (character) a place name
#' @param like (logical) adds a percent-sign before and after place value
#' (a SQL LIKE function). Default: \code{TRUE}
#' @param fuzzy (logical) Uses Levenshtein query to find nearest matches.
#' Default: \code{FALSE}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # search for 'oost', like=TRUE, and not fuzzy
#' mr_geo_code(place = "oost", like = TRUE, fuzzy = FALSE)
#'
#' # search for 'oost', like=FALSE, and not fuzzy
#' mr_geo_code(place = "oost", like = FALSE, fuzzy = FALSE)
#'
#' # search for 'oost', like=FALSE, and fuzzy
#' mr_geo_code(place = "oost", like = FALSE, fuzzy = TRUE)
#'
#' # search for 'oost', like=TRUE, and fuzzy
#' mr_geo_code(place = "oost", like = TRUE, fuzzy = TRUE)
#'
#' # search for 'ast', like=TRUE, and fuzzy
#' mr_geo_code(place = "ast", like = TRUE, fuzzy = TRUE)
#' }
mr_geo_code <- function(place, like = TRUE, fuzzy = FALSE, ...) {
  base <- file.path(mr_base(), "getGazetteerRecordsByName.json/%s/%s/%s")
  url <- sprintf(base, URLencode(place), conv_log(like), conv_log(fuzzy))
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
