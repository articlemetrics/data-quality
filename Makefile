DATE := $(shell date +%Y_%m_%d)

all: message

message:
		print "no all yet"

date:
		echo $(DATE)

crossref:
		cd alerts;\
		Rscript -e 'library(knitr); knit("crossref_report.Rmd", "crossref_report/crossref_report_$(DATE).md")'

outliers:
		cd alerts;\
		Rscript -e 'library(knitr); knit("outliers.Rmd", "outliers/outliers_$(DATE).md")'

otheralms:
		cd alerts;\
		Rscript -e 'library(knitr); knit("other_alms.Rmd", "otheralms/other_alms_$(DATE).md")'

decreasing:
		cd alerts;\
		Rscript -e 'library(knitr); knit("decreasing.Rmd", "decreasing/decreasing_$(DATE).md")'

mendeley:
		cd alerts;\
		Rscript -e 'library(knitr); knit("mendeley.Rmd", "mendeley/mendeley_$(DATE).md")'
