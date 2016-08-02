#' Search for region names
#'
#' @export
#' @param x,q Either a \code{tbl_df}, returned from \code{\link{mr_names}}, or
#' a query as a character string. If a \code{tbl_df}, you must pass a query string to
#' \code{q}. If a query string (character) is passed to \code{x}, leave \code{q}
#' as \code{NULL}
#' @param ... Parameters passed on to \code{\link{agrep}}
#'
#' @return \code{NULL} if no matches found, or a data.frame, or tibble, of class
#' tbl_df (basically, a compact data.frame), with slots:
#' \itemize{
#'  \item name (character) - name of the region, which is a combination of the
#'  name_first and name_second, e.g., Morocco:elevation_10m
#'  \item title (character) - title for the region
#'  \item name_first (character) - first part of the name, e.g., Morocco
#'  \item name_second (character) - second part of the name, e.g., elevation_10m
#' }
#'
#' @examples \dontrun{
#' # Get region names with mr_names() function
#' (res <- mr_names())
#'
#' # to save time, pass in the result from mr_names()
#' mr_names_search(res, q = "EEZ")
#'
#' # if you don't pass in the result from mr_names(), we have to
#' # call mr_names() internally, adding some time
#' mr_names_search("IHO")
#'
#' # more examples, with and without passing in mr_names() output
#' mr_names_search(res, q = "IHO")
#' mr_names_search("Heritage")
#' mr_names_search(res, q = "Heritage")
#' mr_names_search("ecoregions")
#' mr_names_search(res, q = "ecoregions")
#' }
mr_names_search <- function(x, q = NULL, ...) {
  UseMethod('mr_names_search')
}

#' @export
mr_names_search.tbl_df <- function(x, q = NULL, ...) {
  do_regns(x, q, ...)
}

#' @export
mr_names_search.character <- function(x, q = NULL, ...) {
  q <- x
  x <- mr_names()
  do_regns(x, q, ...)
}


do_regns <- function(x, q, ...) {
  nmsps <- sort(unique(x$title))
  tmp <- agrep(q, nmsps, value = TRUE, ...)
  if (length(tmp) == 0) {
    NULL
  } else {
    x[x$title %in% tmp, ]
  }
}
