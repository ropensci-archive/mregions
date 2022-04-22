
# mregions

[![cran
checks](https://cranchecks.info/badges/worst/mregions)](https://cranchecks.info/pkgs/mregions)
[![Build
Status](https://travis-ci.org/ropensci/mregions.svg)](https://travis-ci.org/ropensci/mregions)
[![codecov.io](https://codecov.io/github/ropensci/mregions/coverage.svg?branch=master)](https://codecov.io/github/ropensci/mregions?branch=master)
[![rstudio mirror
downloads](http://cranlogs.r-pkg.org/badges/mregions?color=FAB657)](https://github.com/r-hub/cranlogs.app)
[![cran
version](http://www.r-pkg.org/badges/version/mregions)](https://cran.r-project.org/package=mregions)
[![](https://badges.ropensci.org/53_status.svg)](https://github.com/ropensci/software-review/issues/53)

`mregions` - Get data from <https://www.marineregions.org>

Some data comes from the [Flanders Marine Institute (VLIZ)
geoserver](http://geo.vliz.be/geoserver/web/)

`mregions` is useful to a wide diversity of R users because you get
access to all of the data MarineRegions has, which can help in a variety
of use cases:

-   Visualize marine regions alone
-   Visualize marine regions with associated data paired with analysis
-   Use marine region geospatial boundaries to query data providers
    (e.g., OBIS (<https://www.obis.org>))
-   Geocode - get geolocation data from place names
-   Reverse Geocode - get place names from geolocation data

## Install

``` r
install.packages("mregions")
install.packages("mapview")
```

Development version

``` r
devtools::install_github("ropensci/mregions")
devtools::install_github("wch/webshot")
install.packages("tibble")
```

``` r
library("mregions")

# helper libraries
library("leaflet")
library("tibble")
```

## GeoJSON

<!-- ### Northeast Atlantic -- file too large -->
<!-- Get Data -->
<!-- ```{r} -->
<!-- ne_atlantic <- mr_geojson(key = "World:ne_atlantic") -->
<!-- ``` -->
<!-- Plot Data -->
<!-- ```{r eval=FALSE} -->
<!-- leaflet() %>% -->
<!--   addProviderTiles(provider = 'OpenStreetMap') %>% -->
<!--   addGeoJSON(geojson = ne_atlantic$features) %>% -->
<!--   fitBounds(-160,-52,160,60) -->
<!-- ``` -->

### Marine Ecoregions of the World (MEOW)

Get Data

``` r
ecoregions <- mr_geojson(key = "Ecoregions:ecoregions")
# check number of features (max. = 50)
length(ecoregions$features)
```

    ## [1] 50

Plot Data

``` r
leaflet() %>%
  addProviderTiles(provider = 'OpenStreetMap') %>%
  addGeoJSON(geojson = ecoregions$features) %>%
  fitBounds(-160,-52,160,60)
```

![map1](tools/img/leaf1_ecoregions.png)

### Maritime Boundaries (EEZ)

Get Data

``` r
eezboundaries <- mr_geojson(key = "MarineRegions:eez_boundaries")
```

Plot Data

``` r
leaflet() %>%
  addProviderTiles(provider = 'OpenStreetMap') %>%
  addGeoJSON(geojson = eezboundaries$features) %>%
  fitBounds(-160,-52,160,60)
```

![map2](tools/img/leaf1_eezboundaries.png)

### Morocco Dam

Get Data

``` r
res1 <- mr_geojson(key = "Morocco:dam")
# test
highseas <- mr_geo_code(place = "High Seas")
# check class
class(highseas)
```

    ## [1] "data.frame"

Plot data

``` r
library('leaflet')
leaflet() %>%
  addProviderTiles(provider = 'OpenStreetMap') %>%
  addGeoJSON(geojson = res1$features) %>%
  setView(-3.9, 35, zoom = 10)
```

![map3](tools/img/leaf1.png)

## Shape

### Marine Ecoregions of the World (MEOW)

Get region

``` r
ecoregions_shp <- mr_shp(key = "Ecoregions:ecoregions", maxFeatures = 50)
```

Plot data

``` r
leaflet() %>%
  addProviderTiles(provider = 'OpenStreetMap') %>%
  addPolygons(data = ecoregions_shp)
```

![map4](tools/img/leaf2_ecoregions.png) ### Maritime Boundaries (EEZ)

Get region

``` r
eezboundaries_shp <- mr_shp(key = "MarineRegions:eez_boundaries", maxFeatures = 50)
```

Plot data

``` r
leaflet() %>%
  addProviderTiles(provider = 'OpenStreetMap') %>%
  addPolygons(data = eezboundaries_shp)
```

![map5](tools/img/leaf2_eezboundaries.png)

### Morocco Dam

Get region

``` r
res2 <- mr_shp(key = "MarineRegions:eez_iho_union_v2", maxFeatures = 5)
```

Get helper library

``` r
install.packages("leaflet")
```

Plot data

``` r
library('leaflet')
leaflet() %>%
  addProviderTiles(provider = 'OpenStreetMap') %>%
  addPolygons(data = res2)
```

![map6](tools/img/leaf2.png)

## Convert to WKT

### Marine Ecoregions of the World (MEOW)

From GeoJSON

``` r
ecoregions <- mr_geojson(key = "Ecoregions:ecoregions")
ecoregions_wkt <- mr_as_wkt(ecoregions, fmt = 2)
# check class
class(ecoregions_wkt)
```

<!-- From shp object (`SpatialPolygonsDataFrame`) or file, both work -->
<!-- ```{r eval=FALSE} -->
<!-- ecoregions_shp <- mr_shp(key = "Ecoregions:ecoregions", maxFeatures = 5) -->
<!-- ecoregions_wkt2 <- mr_as_wkt(ecoregions_shp) -->
<!-- #> [1] "GEOMETRYCOLLECTION (POLYGON ((-7.25 ... cutoff -->
<!-- ``` -->

### Morocco Dam

From GeoJSON

``` r
res3 <- mr_geojson(key = "Morocco:dam")
res3_wkt <- mr_as_wkt(res3, fmt = 5)

#> [1] "MULTIPOLYGON (((41.573732 -1.659444, 45.891882 ... cutoff
```

<!-- From shp object (`SpatialPolygonsDataFrame`) or file, both work -->
<!-- ```{r eval=FALSE} -->
<!-- res3_wkt2 <- mr_as_wkt(mr_shp(key = "MarineRegions:eez_iho_union_v2")) -->
<!-- #> [1] "GEOMETRYCOLLECTION (POLYGON ((-7.25 ... cutoff -->
<!-- ``` -->

## Gazetteer Record by Name

### High Seas

``` r
highseas_info <- mr_geo_code(place = "High Seas")
# check class
class(highseas) # data.frame
```

### Marine Ecoregions of the World (MEOW)

``` r
ecoregions_info <- mr_geo_code(place = "Ecoregions")
# check class
class(ecoregions_info) # data.frame
```

## Contributors

-   [Scott Chamberlain](https://github.com/sckott)
-   [Francois Michonneau](https://github.com/fmichonneau)
-   [Pieter Provoost](https://github.com/pieterprovoost)
-   [Michael Sumner](https://github.com/mdsumner)
-   [Lennert Schepers](https://github.com/LennertSchepers)
-   [Salvador Fernandez](https://github.com/salvafern)

## Meta

-   Please [report any issues or
    bugs](https://github.com/ropensci/mregions/issues).
-   License: MIT
-   Get citation information for `mregions` in R doing
    `citation(package = 'mregions')`
-   Please note that this project is released with a [Contributor Code
    of
    Conduct](https://github.com/ropensci/mregions/blob/master/CONDUCT.md).
    By participating in this project you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
