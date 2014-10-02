other ALM sources
========================================================

### Setup

> change directory to /data-quality/alerts/


Install `alm` if not installed already, then load package


```r
# source helper fxns
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
```

### Credentials

You need to give credentials to get alerts data. Make sure to input your own username and password for `user` and `pwd` variables in your `.Rprofile` file, or pass in to the function call itself. `alm_alerts()` looks for `almv4_user` and `almv4_pwd` by default, but those are meant to go with the main PLOS ALM server at `plos.alm.org`. So you can store your username and password in `.Rrofile`, but just call it in via `getOption()` in your script passin to `alm_alerts()`.

### Crossref ALM


```r
url <- "http://det.labs.crossref.org/api/v4/alerts"
user <- getOption('almv4_crossref_user')
pwd <- getOption('almv4_crossref_pwd')
res <- alm_alerts(url = url, user = user, pwd = pwd)
head(res$data)
```

```
##      id level             class_name
## 1 48139 ERROR Net::HTTPNotAcceptable
## 2 48138 ERROR Net::HTTPNotAcceptable
## 3 48137 ERROR Net::HTTPNotAcceptable
## 4 48136 ERROR Net::HTTPNotAcceptable
## 5 48134 ERROR Net::HTTPNotAcceptable
## 6 48135 ERROR Net::HTTPNotAcceptable
##                                                                                                                                                       message
## 1       the server responded with status 406 for http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1109%2Ficmtce.2013.6812406&idtype=doi
## 2       the server responded with status 406 for http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1109%2Ficecco.2013.6718268&idtype=doi
## 3                 the server responded with status 406 for http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1201%2Fb15961-67&idtype=doi
## 4   the server responded with status 406 for http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1016%2Fj.actaastro.2012.03.021&idtype=doi
## 5     the server responded with status 406 for http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1158%2F0008-5472.can-12-1597&idtype=doi
## 6 the server responded with status 406 for http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.7788%2Fboehlau.9783412211387.165&idtype=doi
##   status     hostname
## 1    406 78.46.96.241
## 2    406 78.46.96.241
## 3    406 78.46.96.241
## 4    406 78.46.96.241
## 5    406 78.46.96.241
## 6    406 78.46.96.241
##                                                                                                           target_url
## 1       http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1109%2Ficmtce.2013.6812406&idtype=doi
## 2       http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1109%2Ficecco.2013.6718268&idtype=doi
## 3                 http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1201%2Fb15961-67&idtype=doi
## 4   http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1016%2Fj.actaastro.2012.03.021&idtype=doi
## 5     http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1158%2F0008-5472.can-12-1597&idtype=doi
## 6 http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.7788%2Fboehlau.9783412211387.165&idtype=doi
##   source article unresolved          create_date
## 1   <NA>    <NA>       TRUE 2014-10-02T15:57:28Z
## 2   <NA>    <NA>       TRUE 2014-10-02T15:57:14Z
## 3   <NA>    <NA>       TRUE 2014-10-02T15:57:04Z
## 4   <NA>    <NA>       TRUE 2014-10-02T15:56:48Z
## 5   <NA>    <NA>       TRUE 2014-10-02T15:56:32Z
## 6   <NA>    <NA>       TRUE 2014-10-02T15:56:32Z
```

### Labs ALM


```r
url <- "http://labs.crowdometer.org/api/v4/alerts"
user <- getOption('almv4_ploslabs_user')
pwd <- getOption('almv4_ploslabs_pwd')
res <- alm_alerts(url = url, user = user, pwd = pwd)
head(res$data)
```

```
##       id level      class_name
## 1 130137 ERROR DelayedJobError
## 2 130134 ERROR DelayedJobError
## 3 130135 ERROR DelayedJobError
## 4 130136 ERROR DelayedJobError
## 5 130132 ERROR DelayedJobError
## 6 130133 ERROR DelayedJobError
##                                                   message status
## 1 Failure in nature: Nature Blogs is not in working state     NA
## 2 Failure in nature: Nature Blogs is not in working state     NA
## 3 Failure in nature: Nature Blogs is not in working state     NA
## 4 Failure in nature: Nature Blogs is not in working state     NA
## 5 Failure in nature: Nature Blogs is not in working state     NA
## 6 Failure in nature: Nature Blogs is not in working state     NA
##               hostname target_url source article unresolved
## 1 labs.crowdometer.org         NA nature      NA       TRUE
## 2 labs.crowdometer.org         NA nature      NA       TRUE
## 3 labs.crowdometer.org         NA nature      NA       TRUE
## 4 labs.crowdometer.org         NA nature      NA       TRUE
## 5 labs.crowdometer.org         NA nature      NA       TRUE
## 6 labs.crowdometer.org         NA nature      NA       TRUE
##            create_date
## 1 2014-10-02T16:53:53Z
## 2 2014-10-02T16:53:48Z
## 3 2014-10-02T16:53:48Z
## 4 2014-10-02T16:53:48Z
## 5 2014-10-02T16:53:43Z
## 6 2014-10-02T16:53:43Z
```

### Other sources

I'll add exmaples of working with other data sources as they come online. E.g., eLife and PKP are using the ALM app, but are using an older version that doesn't support the alerts data.
