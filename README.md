mregions
========

[![Build Status](https://travis-ci.org/sckott/mregions.svg)](https://travis-ci.org/sckott/mregions)

`mregions` - Get data from http://marineregions.org

## Install


```r
devtools::install_github("sckott/mregions")
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
## [1] 82
```

## Meta

* Please [report any issues or bugs](https://github.com/sckott/mregions/issues).
* License: MIT
