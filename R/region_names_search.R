#' Search for region names
#'
#' @export
#' @param x,q Either a \code{tbl_df}, returned from \code{\link{region_names}}, or
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
#' (res <- region_names())
#'
#' region_names_search(res, q = "EEZ")
#' region_names_search("IHO")
#' region_names_search(res, q = "IHO")
#' region_names_search("Heritage")
#' region_names_search(res, q = "Heritage")
#' region_names_search("ecoregions")
#' region_names_search(res, q = "ecoregions")
#' }
region_names_search <- function(x, q = NULL, ...) {
  UseMethod('region_names_search')
}

#' @export
region_names_search.tbl_df <- function(x, q = NULL, ...) {
  do_regns(x, q, ...)
}

#' @export
region_names_search.character <- function(x, q = NULL, ...) {
  q <- x
  x <- region_names()
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
