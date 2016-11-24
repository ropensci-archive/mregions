#' list layers
#'
#' @export
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' res <- mr_layers()
#' vapply(res, '[[', '', 'Name')
#' }
mr_layers <- function(...) {
  res <- getter(url = "http://geo.vliz.be/geoserver/MarineRegions/wms",
         list(request = 'GetCapabilities'), format = "text/xml", ...)
  xml <- xml2::xml_children(xml2::read_xml(res))
  xml2::xml_ns_strip(xml)
  layers <- xml2::xml_find_all(xml[[2]], "//Layer")
  lapply(layers, function(z) {
    c(
      extractr(z, "Name"),
      extractr(z, "Title"),
      extractr(z, "Abstract"),
      extractr(z, "KeywordList"),
      extractr(z, "CRS"),
      EX_GeographicBoundingBox = lapply(
        xml2::xml_children(xml2::xml_find_first(z, "EX_GeographicBoundingBox")), function(w) {
        as.list(
          stats::setNames(
            xml2::xml_text(w),
            xml2::xml_name(w)
          )
        )
      }),
      bounding_box_crs = lapply(xml2::xml_find_all(z, "BoundingBox"), function(w) {
        as.list(xml2::xml_attrs(w))
      }),
      style = {
        styletmp <- list(xml2::as_list(xml2::xml_find_first(z, "Style")))
        if (length(styletmp[[1]]) == 0) list(NA_character_) else styletmp
      }
    )
  })
}

extractr <- function(z, node_name) {
  tmp <- xml2::xml_find_all(z, node_name)
  if (length(tmp) == 0) {
    stats::setNames(list(NA_character_), node_name)
  } else {
    if (length(xml2::xml_children(tmp)) > 0) {
      vals <- xml2::xml_children(tmp)
    } else {
      vals <- tmp
    }
    as.list(
      stats::setNames(
        list(xml2::xml_text(vals)),
        xml2::xml_name(tmp)[1]
      )
    )
  }
}
