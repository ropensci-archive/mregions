mregions
========

[![Build Status](https://travis-ci.org/ropenscilabs/mregions.svg)](https://travis-ci.org/ropenscilabs/mregions)
[![codecov.io](https://codecov.io/github/ropenscilabs/mregions/coverage.svg?branch=master)](https://codecov.io/github/ropenscilabs/mregions?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/mregions?color=FAB657)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/mregions)](https://cran.r-project.org/package=mregions)

`mregions` - Get data from http://marineregions.org

Some data comes from the [Flanders Marine Institute (VLIZ) geoserver](http://geo.vliz.be/geoserver/web/)

## Install


```r
devtools::install_github("ropenscilabs/mregions")
```


```r
library("mregions")
```

## GeoJSON

Get region


```r
res <- region_geojson(name = "Turkmen Exclusive Economic Zone")
```

Get helper library


```r
install.packages("leaflet")
```

Plot data


```r
library('leaflet')
leaflet() %>%
  addProviderTiles(provider = 'OpenStreetMap') %>%
  addGeoJSON(geojson = res$features) %>%
  setView(53, 40, zoom = 6)
```

![map](http://f.cl.ly/items/0c2c2Z143d2H3F142c35/Screen%20Shot%202015-12-09%20at%2010.01.52%20AM.png)

## Shape

Get region


```r
res <- region_shp(name = "Belgian Exclusive Economic Zone")
```

Get helper library


```r
install.packages("leaflet")
```

Plot data


```r
library('leaflet')
leaflet() %>%
  addProviderTiles(provider = 'OpenStreetMap') %>%
  addPolygons(data = res)
```

![map2](http://f.cl.ly/items/1m3R2p241S1u1n3r141R/Screen%20Shot%202015-12-09%20at%209.36.19%20AM.png)

## Convert to WKT

From geojson


```r
res <- region_geojson(key = "MarineRegions:eez_33176")
as_wkt(res, fmt = 5)

#> [1] "MULTIPOLYGON (((41.573732 -1.659444, 45.891882 ... cutoff
```

From shp object (`SpatialPolygonsDataFrame`) or file, both work


```r
## path to wkt
as_wkt(region_shp(key = "MarineRegions:eez_33176", read = FALSE))
## spatial object to wkt
as_wkt(region_shp(key = "MarineRegions:eez_33176", read = TRUE))

#> [1] "MULTIPOLYGON (((41.573732 -1.659444, 45.891882 ... cutoff
```

## Get OBIS EEZ ID


```r
res <- region_names()
obis_eez_id(res[[1]]$title)
```

```
## integer(0)
```

## Meta

* Please [report any issues or bugs](https://github.com/ropenscilabs/mregions/issues).
* License: MIT
* Get citation information for `mregions` in R doing `citation(package = 'mregions')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
