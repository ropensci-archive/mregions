mregions 0.1.4
==============

<http://marineregions.org/> changed some of their services. Thus, 
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
