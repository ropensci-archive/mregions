#' Get region names
#'
#' @export
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' region_names()
#' }
region_names <- function(...) {
  args <- list(SERVICE = 'WFS', REQUEST = 'GetCapabilities', outputFormat = 'a')
  res <- m_GET(vliz_base(), args, ...)
  xml <- xml2::read_xml(res)
  features <- xml_children(xml_children(xml)[[4]])
  lapply(features, function(z) {
    list(name = ex_name(z, 1), title = ex_name(z, 2))
  })
}
