mregions 0.1.9
==============

### DEPENDENCY SWITCH

* Remove dependency on rgeos and rgdal as they were archived on CRAN. Users 
should not notice the difference

mregions 0.1.8
==============

### DEPENDENCY SWITCH

* Switch wellknown dependency to geojson, geojsonio and geojsonsf. Users should 
not notice the difference
* Remove function relying on OBIS API as it has changed
* Change package maintainer Lennert Schepers -> Salvador Fernandez


mregions 0.1.6
==============

### BUG FIXES

* Bug fixes for slight changes in the Marineregions web services


mregions 0.1.4
==============

<https://marineregions.org/> changed some of their services. Thus,
we had to change the way some functions work, remove functionality
of some parameters, and add new functions. We are still in the process
of making it all work smoothly.

### NEW FEATURES

* new function `mr_features_get()` to fetch features of many different
data types, including geojson, shp, kml, and more.
* new function `mr_layers()` to list layers

### MINOR IMPROVEMENTS

* Tidying man pages throughout package to reduce down to 80 line width
* `mr_names()` changed behavior. You used to be able to get all names/regions,
but now you have to specify a layer you want information for.
* `mr_names_search()` internals changed to account for changes in
`mr_names()`.



mregions 0.1.0
==============

### NEW FEATURES

* released to CRAN
