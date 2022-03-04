#' Get OBIS EEZ id
#'
#' @export
#' @param x (character) An Exclusive Economic Zone name
#' @return An integer EEZ ID if a match found in list of EEZ's, or
#' `NULL` if no match found.
#' @details internally we use the OBIS API to retrieve an EEZ id.
#'
#' Matching internally is case insensitive, as we convert your input and match
#' against EEZ names that are all lower case.
#' @examples \dontrun{
#' # You can get EEZ names via the mr_names() function
#' (res <- mr_names('MarineRegions:eez_boundaries'))
#' mr_obis_eez_id(res$eez1[19])
#'
#' # Or pass in a name
#' mr_obis_eez_id("Bulgarian Exclusive Economic Zone")
#'
#' # case doesn't matter
#' mr_obis_eez_id("bulgarian exclusive economic zone")
#'
#' # No match, gives NULL
#' mr_obis_eez_id("stuff things")
#' }
mr_obis_eez_id <- function(x) {
  eezs <- obis_eez()
  eezs[tolower(eezs$name) %in% tolower(x), "id"] %&% NULL
}

obis_eez <- function() {
  rs <- getter(file.path(obis_base(), "eez"),
               format = "application/json;charset=UTF-8")
  jsonlite::fromJSON(rs)$results
}

obis_base <- function() "https://api.obis.org"
