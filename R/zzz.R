#vliz_base <- function() "http://geo.vliz.be/geoserver/MarineRegions/ows"
vliz_base <- function() "http://geo.vliz.be/geoserver/ows"
mr_base <- function() "http://marineregions.org/rest"

m_GET <- function(url, args, path = NULL, overwrite = NULL, format = "application/xml", ...) {
  if (args$outputFormat == "SHAPE-ZIP") {
    tt <- httr::GET(url, query = args, httr::write_disk(path = path, overwrite = overwrite), ...)
    httr::stop_for_status(tt)
    file <- tt$request$output$path
    on.exit(unlink(file))
    exdir <- sub(".zip", "", path)
    utils::unzip(file, exdir = exdir)
    if (length(list.files(exdir)) == 0) {
      unlink(file)
      unlink(exdir, TRUE)
      stop("unzip failed, check query, try again - & removed files", call. = FALSE)
    }
    path.expand(list.files(exdir, pattern = ".shp", full.names = TRUE))
  } else {
    getter(url, args, format, ...)
  }
}

getter <- function(url, args = list(), format, ...) {
  tt <- httr::GET(url, query = args, ...)
  err_handle(tt, format)
  contutf8(tt)
}

getter2 <- function(url, args = list(), format, path, ...) {
  if (format %in% c('application/zip')) {
    tt <- httr::GET(url, query = args,
                    write_disk(path = path, overwrite = TRUE), ...)
    err_handle(tt, format)
    tt$request$output$path
  } else {
    tt <- httr::GET(url, query = args, ...)
    err_handle(tt, format)
    contutf8(tt)
  }
}

contutf8 <- function(x) httr::content(x, "text", encoding = "UTF-8")

err_handle <- function(x, format) {
  if (x$status_code > 201) {
    stop(httr::http_status(x)$message, call. = FALSE)
  } else {
    if (x$headers$`content-type` != format) {
      stop("Region not found or no results found, try another search", call. = FALSE)
    }
  }
}

ex_name <- function(x, y) {
  xml2::xml_text(xml2::xml_children(x)[[y]])
}

check4pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

make_args <- function(format, name, key, maxFeatures) {
  format <- match.arg(format, c('geojson', 'shp'))
  format <- switch(format, geojson = "application/json", shp = "SHAPE-ZIP")
  key <- nameorkey(name, key)
  list(service = 'WFS', version = '1.0.0', request = 'GetFeature',
       typeName = strsplit(key, ":")[[1]][2], maxFeatures = maxFeatures, outputFormat = format)
}

nameorkey <- function(name, key) {
  stopifnot(xor(!is.null(name), !is.null(key)))
  if (is.null(key)) {
    nms <- mr_names()
    nms[nms$title == name, ]$name
  } else {
    key
    #strsplit(key, ":")[[1]][2]
  }
}

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

`%&%` <- function(x, y) {
  if (length(x) == 0) y else x
}
