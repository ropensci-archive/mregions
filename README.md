mregions
========

[![Build Status](https://travis-ci.org/sckott/mregions.svg)](https://travis-ci.org/sckott/mregions)

`mregions` - Get data from http://marineregions.org

## Install


```r
devtools::install_github("ropensci/mregions")
```


```r
library("mregions")
```

## 

Get region


```r
res <- region(name = "Turkmen Exclusive Economic Zone", format = "geojson")
```

Get helper library


```r
install.packages("geojsonio")
```

Plot data


```r
library("geojsonio")
as.json(res) %>% map_leaf
```

![map](http://f.cl.ly/items/292D3I32251l1z3j0i1d/Screen%20Shot%202015-12-08%20at%2011.16.18%20PM.png)

## Meta

* Please [report any issues or bugs](https://github.com/sckott/mregions/issues).
* License: MIT
