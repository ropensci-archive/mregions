#' Get region names
#'
#' @export
#' @param query Query term
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' (res <- region_names())
#' vapply(res, "[[", "", "name")
#' sort(unique(vapply(res, "[[", "", "name_first")))
#' sort(unique(vapply(res, "[[", "", "name_second")))
#' vapply(res, "[[", "", "title")
#'
#' # search
#' region_names_search(query = "EEZ")
#' region_names_search(query = "IHO")
#' region_names_search(query = "Heritage")
#' region_names_search(query = "ecoregions")
#' }
region_names <- function(...) {
  args <- list(SERVICE = 'WFS', REQUEST = 'GetCapabilities', outputFormat = 'a')
  res <- m_GET(vliz_base(), args, format = "application/xml", ...)
  xml <- xml2::read_xml(res)
  features <- xml2::xml_children(xml2::xml_children(xml)[[4]])
  tt <- lapply(features, function(z) {
    list(name = ex_name(z, 1), title = ex_name(z, 2))
  })
  lapply(tt, function(x) {
    gg <- strsplit(x$name, ":")[[1]][[2]]
    gg <- if (grepl("eez", gg)) "eez" else gg
    utils::modifyList(x, list(name_first = strsplit(x$name, ":")[[1]][[1]], name_second = gg))
  })
}

#' @export
#' @rdname region_names
region_names_search <- function(query) {
  res <- region_names()
  nmsps <- sort(unique(pluck(res, "title", "")))
  tmp <- agrep(query, nmsps, value = TRUE)
  if (length(tmp) == 0) {
    NULL
  } else {
    res[sapply(res, function(x) x$title %in% tmp)]
  }
}

# nms_matches <- list(
#   comarge = "Continental margins between 140m and 3500m depth (IFREMER - COMARGE, 2009)",
#   relief = "ETOPO1 Global Relief Model",
#   eez = "Exclusive Economic Zones Boundaries (EEZ)",
#   fao = "FAO Fishing Areas",
#   gebco_undersea = "GEBCO Gazetteer of undersea feature names",
#   gebco_general = "General Bathymetric Chart of the Oceans (GEBCO)",
#   contourite = "Global contourite distribution Shapefile",
#   ices_ecoregions = "ICES Ecoregions",
#   icesecoregions = "ICES Ecoregions",
#   ices_areas = "ICES Statistical areas",
#   ices_statistical_rectangles = "ICES Statistical rectangles",
#   iho = "IHO Sea Areas",
#   iho_quadrants_20150810 = "IHO Sea Areas",
#   lme = "Large Marine Ecosystems of the World",
#   longhurst = "Longhurst Biogeographical Provinces",
#   marlandzones = "Marine and land zones: the union of world country boundaries and EEZ's",
#   meow = "Marine Ecoregions of the World, MEOW (Spalding et al., 2007)",
#   mar_eez_iho = "Marineregions: intersect of EEZ's and IHO areas",
#   ospar_boundaries = "OSPAR Boundaries and Regions",
#   ospar_regions = "OSPAR Boundaries and Regions",
#   marbound = "Statistics on Marbound and IHO (Costello et al., 2011)",
#   tdwg = "TDWG Geography shapefiles",
#   tnc = "Terrestrial Ecoregional Boundaries Shapefile (TNC)",
#   nafo = "The NAFO Convention Area",
#   seavox_v16 = "The SeaVoX Salt and Fresh Water Body Gazetteer",
#   seavox_sea_area_polygons_v13 = "The SeaVoX Salt and Fresh Water Body Gazetteer",
#   worldheritagemarineprogramme = "World Marine Heritage Sites",
#   fadaregions = "FADA Faunistic Regions",
#   arcticmarineareas = "arcticmarineareas",
#   boundaries = "boundaries",
#   coasts_per_ocean = "coasts_per_ocean",
#   coasts_subnational = "coasts_subnational",
#   cross_dateline_polygons = "cross_dateline_polygons",
#   fadaregions = "fadaregions",
#   gsas_mediterraneanfishingzones = "gsas_mediterraneanfishingzones",
#   world_bay_gulf = "world_bay_gulf",
#   world_countries_coasts = "world_countries_coasts",
#   world_estuary_delta = "world_estuary_delta"
# )
