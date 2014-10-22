PLOS ALM Data Quality
=====================

This repo holds work on data quality for data from the PLOS altmetrics application, including for:

* Monthly reports inspection, see [monthly](monthly/)
* Alerts inspection, see [alerts](alerts/)

To run reports use make commands. See the Makefile for available commands. E.g. to make the Crossref Report in `alerts/crossref_report.Rmd`, type `make crossref` in your local version of this repo.

## Monthly reports

Montly reports inspection deals with:

* loading data
* cleaning data
* various summaries by doi, metric, etc.
* Visualize temporal change within __the same__ doi
* Visualize relationship among various metrics for __different__ dois

## Alerts

Alerts deals with:

* Collection of alerts data using the [alm R package][almpkg] (& Python way of doing this as well when the client is ready)
* Extraction of any data within alert messages
* Collection of further altmetrics data to help understand alerts data
* Visualizations to look for patterns
* Statistical models to find patterns

Alerts data is availabe usig the v4 API via R using the [alm package][almpkg]. See [the alerts folder](alerts/) for examples of its use. You will need to have role of `Staff` or `Admin` in the ALM application to get alerts data. If you are one of those, you'll need your username and password to the site.

[almpkg]: https://github.com/ropensci/alm
