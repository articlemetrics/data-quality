DATE := $(shell date +%Y_%m_%d)

all: message

message:
		print "no all yet"

date:
		echo $(DATE)

alerts: crossref outliers otheralms decreasing mendeley

crossref:	
		cd alerts;\
		Rscript -e 'library(knitr); knit("crossref_report.Rmd", "crossref_report_$(DATE).md")'

mendeley:
		cd alerts;\
		Rscript -e 'library(knitr); knit("mendeley.Rmd", "mendeley_report_$(DATE).md")'

pkp:
		cd alerts;\
		Rscript -e 'library(knitr); knit("pkp_report.Rmd", "pkp_report_$(DATE).md")'

outliers:
		cd alerts;\
		Rscript -e 'library(knitr); knit("outliers.Rmd", "outliers_$(DATE).md")'

otheralms:
		cd alerts;\
		Rscript -e 'library(knitr); knit("other_alms.Rmd", "other_alms_$(DATE).md")'

decreasing:
		cd alerts;\
		Rscript -e 'library(knitr); knit("decreasing.Rmd", "decreasing_$(DATE).md")'

mendeley:
		cd alerts;\
		Rscript -e 'library(knitr); knit("mendeley.Rmd", "mendeley_$(DATE).md")'

sumalerts:
		cd alerts;\
		Rscript -e 'library(knitr); library(rmarkdown); knit("summary_alerts.Rmd", "summary_alerts_$(DATE).md"); render("summary_alerts_$(DATE).md", pdf_document())'

summonthly:
		cd monthly;\
		Rscript -e 'library(knitr); library(rmarkdown); knit("summary_monthly.Rmd", "summary_monthly_$(DATE).md"); render("summary_monthly_$(DATE).md", pdf_document())'
