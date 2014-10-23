Summary of ALM alerts investigations
====================================

### Date

Created on 2014-10-22 19:05:37

### Setup

> change directory to /data-quality/alerts/

Install `alm` if not installed already, then load package

    # source functions
    source("helper_fxns.R")

    # install.packages('stringr')
    # devtools::install_github("ropensci/alm", ref="dev")
    library('stringr')
    library('alm')
    library('plyr')
    library('dplyr')
    library('tidyr')
    library('assertthat')
    library('ggplot2')
    library('lubridate')
    library('knitr')

### Stuff

    print("hello world")

    ## [1] "hello world"
