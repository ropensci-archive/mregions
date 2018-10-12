#' Search for region names
#'
#' @export
#' @param x,q Either a `tbl_df`, returned from [mr_names()], or
#' a query as a character string. If a `tbl_df`, you must pass a query
#' string to `q`. If a query string (character) is passed to `x`,
#' leave `q` as `NULL`
#' @param ... Parameters passed on to [agrep()]
#'
#' @return `NULL` if no matches found, or a data.frame, or tibble, of class
#' `tbl_df`, with slots:
#' - name (character) - name of the region, which is a combination of the
#'  name_first and name_second, e.g., Morocco:elevation_10m
#' - title (character) - title for the region
#' - name_first (character) - first part of the name, e.g., Morocco
#' - name_second (character) - second part of the name, e.g., elevation_10m
#'
#' @examples \dontrun{
#' # Get region names with mr_names() function
#' (res <- mr_names("MarineRegions:eez"))
#'
#' # to save time, pass in the result from mr_names()
#' mr_names_search(res, q = "Amer")
#'
#' # if you don't pass in the result from mr_names(), we have to
#' # call mr_names() internally, adding some time
#' mr_names_search(x = "iho", q = "Black")
#' mr_names_search(x = "iho", q = "Sea")
#'
#' # more examples
#' mr_names_search("iho", "Sea")
#' (res <- mr_names("MarineRegions:iho"))
#' mr_names_search(res, q = "Sea")
#' }
mr_names_search <- function(x, q = NULL, ...) {
  UseMethod('mr_names_search')
}

#' @export
mr_names_search.tbl_df <- function(x, q = NULL, ...) {
  do_regns(x, q, x$layer[1], ...)
}

#' @export
mr_names_search.character <- function(x, q = NULL, ...) {
  stopifnot(tolower(x) %in% c('eez', 'eez_boundaries', 'iho', 'fao', 'lme'))
  mrx <- paste0("MarineRegions:", tolower(x))
  xx <- mr_names(mrx)
  do_regns(xx, q, mrx, ...)
}

# helper
do_regns <- function(x, q, mrx = NULL, ...) {
  name_field <- switch(
    mrx,
    `MarineRegions:eez` = "geoname",
    `MarineRegions:eez_boundaries` = "geoname",
    `MarineRegions:iho` = "name",
    `MarineRegions:fao` = "name",
    `MarineRegions:lme` = "lme_name"
  )
  nmsps <- sort(unique(x[[name_field]]))
  tmp <- agrep(q, nmsps, value = TRUE, ignore.case = TRUE, ...)
  if (length(tmp) == 0) {
    NULL
  } else {
    x[x[[name_field]] %in% tmp, ]
  }
}
