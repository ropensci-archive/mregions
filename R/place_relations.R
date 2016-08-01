##' Get related records based on their MRGID.
##'
##' @export
##' @title Related records
##' @param mrgid (numeric) the MRGID (Marineregions Global Identifier) for the
##'     record of interest
##' @param direction (character) in which direction of the geographical hierarchy
##'     should the records be retrieved? Default: \code{upper}
##' @param type (character) what kind of relations should the records retrieve
##'     have with the place? Default: \code{partof}
##' @param ... curl options to be passed on to \code{\link[httr]{GET}}
##' @examples \dontrun{
##' ## geocode to get geospatial data for a place name
##' (tikehau <- mr_geo_code("tikehau"))
##'
##' ## then pass in in an MRGID as the first parameter
##' mr_place_relations(tikehau$MRGID)
##'
##' ## Set direction='both'
##' mr_place_relations(tikehau$MRGID, direction = "both")
##'
##' ## Set type to various other options
##' mr_place_relations(307, type = "adjacentto")
##' mr_place_relations(414, type = "similarto")
##' mr_place_relations(4177, type = "all")
##' }
##' @author Francois Michonneau <francois.michonneau@gmail.com>
mr_place_relations <- function(mrgid, direction = c("upper", "lower", "both"),
                            type = c("partof", "partlypartof", "adjacentto",
                                     "similarto", "administrativepartof",
                                     "influencedby", "all"), ...) {

    direction <- match.arg(direction)
    type <- match.arg(type)
    base <- paste0(mr_base(), "/getGazetteerRelationsByMRGID.json/%s/%s/%s")
    url <- sprintf(base, mrgid, direction, type)
    res <- httr::GET(url, ...)
    httr::stop_for_status(res)
    jsonlite::fromJSON(contutf8(res), flatten = TRUE)
}
