#' Get region names
#'
#' @export
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#'
#' @return a data.frame, or tibble, of class tbl_df
#'
#' @examples \dontrun{
#' (res <- region_names())
#' res$name
#' sort(unique(res$name_first))
#' sort(unique(res$name_second))
#' res$title
#' }
region_names <- function(...) {
  args <- list(SERVICE = 'WFS', REQUEST = 'GetCapabilities', outputFormat = 'a')
  res <- m_GET(vliz_base(), args, format = "application/xml", ...)
  xml <- xml2::read_xml(res)
  features <- xml2::xml_children(xml2::xml_children(xml)[[4]])
  tt <- lapply(features, function(z) {
    list(name = ex_name(z, 1), title = ex_name(z, 2))
  })
  tmp <- lapply(tt, function(x) {
    gg <- strsplit(x$name, ":")[[1]][[2]]
    gg <- if (grepl("eez", gg)) "eez" else gg
    utils::modifyList(x, list(name_first = strsplit(x$name, ":")[[1]][[1]], name_second = gg))
  })
  dd <- data.table::setDF(data.table::rbindlist(tmp, use.names = TRUE, fill = TRUE))
  tibble::as_data_frame(dd)
}
