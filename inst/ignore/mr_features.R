#' Get metadata for regions
#'
#' @export
#' @param type a region type, e.g., "MarineRegions:eez"
#' @param maxFeatures (integer) Number of features. Default: 500
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#'
#' @return a data.frame, or tibble, of class tbl_df (basically, a compact
#' data.frame), with slots:
#' \itemize{
#'  \item name (character) - name of the region, which is a combination of the
#'  name_first and name_second, e.g., Morocco:elevation_10m
#'  \item title (character) - title for the region
#'  \item name_first (character) - first part of the name, e.g., Morocco
#'  \item name_second (character) - second part of the name, e.g., elevation_10m
#' }
#'
#' @examples \dontrun{
#' (res <- mr_features(type = "MarineRegions:eez"))
#' res
#' }
mr_features <- function(type, maxFeatures = 100, ...) {
  args <- list(service = 'WFS', request = 'GetFeature',
               typeName = type, maxFeatures = maxFeatures, version = "1.0.0")
  res <- getter("http://geo.vliz.be/geoserver/MarineRegions/ows",
                args, format = "text/xml; subtype=gml/2.1.2", ...)
  xml <- xml2::read_xml(res)
  feats <- xml2::xml_find_all(xml, "//gml:featureMember")
  lapply(feats, function(z) {
    xml_text(xml2::xml_find_all(z, ".//MarineRegions:*"))
  })

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

slugs <- list(
  "MarineRegions:eez",
  "MarineRegions:eez_boundaries",
  "MarineRegions:eez_iho_union_v2",
  "MarineRegions:eez_land_v1",
  "MarineRegions:iho",
  "MarineRegions:fao",
  "MarineRegions:lme",
  "MarineRegions:icesecoregions",
  "MarineRegions:ices_areas",
  "MarineRegions:ices_statistical_rectangles",
  "MarineRegions:ospar_boundaries",
  "MarineRegions:longhurst",
  "MarineRegions:seavox_v16",
  "MarineRegions:worldheritagemarineprogramme"
)
