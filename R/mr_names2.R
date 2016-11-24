#' Get region names - v2
#'
#' @export
#' @param layer A layer name, e.g., "MarineRegions:eez"
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#'
#' @return a data.frame, or tibble, of class tbl_df (basically, a compact
#' data.frame), with slots:
#' \itemize{
#'  \item layer (character) - name of the layer (e.g. MarineRegions:eez)
#'  \item name_first (character) - first part of the name, e.g., MarineRegions
#'  \item name_second (character) - second part of the name, e.g., eez
#'  \item id (character) - the feature ID
#' }
#' additional columns vary by layer
#'
#' @examples \dontrun{
#' # mr_names gives a tidy data.frame
#' (res <- mr_names2("MarineRegions:eez"))
#' (res <- mr_names2('MarineRegions:eez_boundaries'))
#' (res <- mr_names2('MarineRegions:iho'))
#' (res <- mr_names2('MarineRegions:fao'))
#' (res <- mr_names2('MarineRegions:lme'))
#' }
mr_names2 <- function(layer) {
  args <- list(service = 'WFS', request = 'GetFeature',
               typeName = layer, version = "2.0.0",
               propertyName = prop_name_map[[layer]])
  res <- getter("http://geo.vliz.be/geoserver/MarineRegions/wfs",
                args, format = "text/xml; subtype=gml/3.2")
  xml <- xml2::read_xml(res)
  xml2::xml_ns_strip(xml)
  tibble::as_data_frame(data.table::setDF(data.table::rbindlist(
    lapply(xml2::xml_find_all(xml, "//wfs:member"), function(z) {
      c(
        layer = layer,
        name_first = strsplit(layer, ":")[[1]][[1]],
        name_second = strsplit(layer, ":")[[1]][[2]],
        id = xml_attrs(xml_find_first(z, layer))[[1]],
        sapply(prop_node_map[[layer]], function(x) {
          pull_node(xml2::xml_find_first(z, paste0(".//", x)))
        }, USE.NAMES = FALSE)
      )
    }), fill = TRUE, use.names = TRUE)))
}

pull_node <- function(x) {
  as.list(
    stats::setNames(
      xml2::xml_text(x),
      xml2::xml_name(x)
    )
  )
}

prop_name_map <- list(
  `MarineRegions:eez` = 'mrgid,geoname',
  `MarineRegions:eez_boundaries` = 'eez1',
  `MarineRegions:iho` = 'name,mrgid',
  `MarineRegions:fao` = 'name,mrgid',
  `MarineRegions:lme` = 'lme_name,objectid,mrgid'
)

prop_node_map <- list(
  `MarineRegions:eez` = c('MarineRegions:mrgid', 'MarineRegions:geoname'),
  `MarineRegions:eez_boundaries` = 'MarineRegions:eez1',
  `MarineRegions:iho` = c('gml:name', 'MarineRegions:mrgid'),
  `MarineRegions:fao` = c('gml:name', 'MarineRegions:mrgid'),
  `MarineRegions:lme` = c('MarineRegions:lme_name', 'MarineRegions:objectid',
                          'MarineRegions:mrgid')
)
