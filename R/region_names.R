#' Get region names
#'
#' @export
#' @param x Region name
#' @examples \dontrun{
#' region_names()
#' }
region_names <- function(x) {
  args <- list(SERVICE = 'WFS', REQUEST = 'GetCapabilities')
  res <- m_GET(vliz_base(), args)
  xml <- xml2::read_xml(res)
  features <- xml_children(xml_children(xml)[[4]])
  lapply(features, function(z) {
    list(name = ex_name(z, 1), title = ex_name(z, 2))
  })
}

vliz_base <- function(x) "http://geo.vliz.be/geoserver/MarineRegions/ows"

m_GET <- function(url, args) {
  tt <- GET(url, query = args)
  stop_for_status(tt)
  content(tt, "text")
}

ex_name <- function(x, y) {
  xml_text(xml_children(x)[[y]])
}
