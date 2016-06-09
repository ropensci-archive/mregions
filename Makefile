all: move rmd2md

move:
		cp inst/vign/mregions_vignette.md vignettes;\
		cp -r inst/vign/figure/ vignettes/figure/

rmd2md:
		cd vignettes;\
		mv mregions_vignette.md mregions_vignette.Rmd
