all: move rmd2md

move:
		cp inst/vign/mregions.md vignettes;\
		cp -r inst/vign/figure/ vignettes/figure/

rmd2md:
		cd vignettes;\
		mv mregions.md mregions.Rmd
