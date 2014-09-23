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
##      id level              class_name
## 1 16639 ERROR       Net::HTTPConflict
## 2 16638 ERROR       Net::HTTPConflict
## 3 16637  WARN Net::HTTPRequestTimeOut
## 4 16636  WARN Net::HTTPRequestTimeOut
## 5 16635 ERROR       Net::HTTPConflict
## 6 16634 ERROR       Net::HTTPConflict
##                                                                                                                            message
## 1               the server responded with status 409 for http://144.76.226.211:5984/alm/pmceurope:10.1210%2Fjc.2013-3874 with rev 
## 2               the server responded with status 409 for http://144.76.226.211:5984/alm/pmceurope:10.1210%2Fen.2013-2107 with rev 
## 3          request timed out for http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1201%2Fb17231-4&idtype=doi
## 4 request timed out for http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1017%2Fs0269889714000052&idtype=doi
## 5       the server responded with status 409 for http://144.76.226.211:5984/alm/pmceurope:10.1182%2Fblood-2014-04-571091 with rev 
## 6           the server responded with status 409 for http://144.76.226.211:5984/alm/pmceurope:10.1177%2F2325957413500534 with rev 
##   status     hostname
## 1    409 78.46.96.241
## 2    409 78.46.96.241
## 3    408 78.46.96.241
## 4    408 78.46.96.241
## 5    409 78.46.96.241
## 6    409 78.46.96.241
##                                                                                                   target_url
## 1                                            http://144.76.226.211:5984/alm/pmceurope:10.1210%2Fjc.2013-3874
## 2                                            http://144.76.226.211:5984/alm/pmceurope:10.1210%2Fen.2013-2107
## 3          http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1201%2Fb17231-4&idtype=doi
## 4 http://www.pubmedcentral.nih.gov/utils/idconv/v1.0/?format=json&ids=10.1017%2Fs0269889714000052&idtype=doi
## 5                                    http://144.76.226.211:5984/alm/pmceurope:10.1182%2Fblood-2014-04-571091
## 6                                        http://144.76.226.211:5984/alm/pmceurope:10.1177%2F2325957413500534
##      source article unresolved          create_date
## 1 pmceurope    <NA>       TRUE 2014-09-23T11:38:32Z
## 2 pmceurope    <NA>       TRUE 2014-09-23T11:37:34Z
## 3      <NA>    <NA>       TRUE 2014-09-23T11:31:18Z
## 4      <NA>    <NA>       TRUE 2014-09-23T11:30:53Z
## 5 pmceurope    <NA>       TRUE 2014-09-23T09:54:16Z
## 6 pmceurope    <NA>       TRUE 2014-09-23T09:26:49Z
```

### Labs ALM

> Note: as of 2014-09-20 this ALM server is down


```r
url <- "http://labs.crowdometer.org/api/v4/alerts"
user <- getOption('almv4_ploslabs_user')
pwd <- getOption('almv4_ploslabs_pwd')
res <- alm_alerts(url = url, user = user, pwd = pwd)
head(res$data)
```

```
##      id level                class_name
## 1 75843 FATAL Faraday::ResourceNotFound
## 2 75840 FATAL Faraday::ResourceNotFound
## 3 75841 FATAL Faraday::ResourceNotFound
## 4 75842 FATAL Faraday::ResourceNotFound
## 5 75837 FATAL Faraday::ResourceNotFound
## 6 75838 FATAL Faraday::ResourceNotFound
##                                                  message status
## 1 DOI 10.1164/ajrccm.156.2.9610043 could not be resolved    404
## 2     DOI 10.1164/ajrccm.170.2.952 could not be resolved    404
## 3 DOI 10.1164/ajrccm.158.5.9710009 could not be resolved    404
## 4 DOI 10.1164/ajrccm.164.3.2005003 could not be resolved    404
## 5     DOI 10.1164/ajrccm/139.2.422 could not be resolved    404
## 6            DOI 10.1165/rcmb.f253 could not be resolved    404
##               hostname                                     target_url
## 1 labs.crowdometer.org http://www.atsjournals.org/action/cookieabsent
## 2 labs.crowdometer.org http://www.atsjournals.org/action/cookieabsent
## 3 labs.crowdometer.org http://www.atsjournals.org/action/cookieabsent
## 4 labs.crowdometer.org http://www.atsjournals.org/action/cookieabsent
## 5 labs.crowdometer.org http://www.atsjournals.org/action/cookieabsent
## 6 labs.crowdometer.org http://www.atsjournals.org/action/cookieabsent
##   source                      article unresolved          create_date
## 1     NA 10.1164/ajrccm.156.2.9610043       TRUE 2014-09-23T17:55:12Z
## 2     NA     10.1164/ajrccm.170.2.952       TRUE 2014-09-23T17:55:11Z
## 3     NA 10.1164/ajrccm.158.5.9710009       TRUE 2014-09-23T17:55:11Z
## 4     NA 10.1164/ajrccm.164.3.2005003       TRUE 2014-09-23T17:55:11Z
## 5     NA     10.1164/ajrccm/139.2.422       TRUE 2014-09-23T17:55:10Z
## 6     NA            10.1165/rcmb.f253       TRUE 2014-09-23T17:55:10Z
```

### Other sources

I'll add exmaples of working with other data sources as they come online. E.g., eLife and PKP are using the ALM app, but are using an older version that doesn't support the alerts data.
