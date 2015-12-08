vliz_base <- function(x) "http://geo.vliz.be/geoserver/MarineRegions/ows"

m_GET <- function(url, args) {
  tt <- GET(url, query = args)
  stop_for_status(tt)
  content(tt, "text")
}

ex_name <- function(x, y) {
  xml_text(xml_children(x)[[y]])
}
