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
##      id level                 class_name
## 1 16197 ERROR              StandardError
## 2 16196 FATAL TooManyErrorsBySourceError
## 3 16195 ERROR              StandardError
## 4 16194 FATAL  Faraday::ResourceNotFound
## 5 16193 ERROR        Net::HTTPBadRequest
## 6 16192 ERROR      Net::HTTPUnauthorized
##                                                                                                                                                                                                                                                                                                                                        message
## 1                                                                                                                                                                                                                                                                   Error monitoring workers, only 1 of 25 workers running. Workers restarted.
## 2                                                                                                                                                                                                                                                                          Facebook has exceeded maximum failed queries. Disabling the source.
## 3                                                                                                                                                                                                                                                                   Error monitoring workers, only 1 of 25 workers running. Workers restarted.
## 4                                                                                                                                                                                                                                                                                                  DOI 10.1021/mp5002119 could not be resolved
## 5 the server responded with status 400 for https://graph.facebook.com/fql?access_token=cbe96f83275b52989a2a70cdefe35712&q=select%20url,%20share_count,%20like_count,%20comment_count,%20click_count,%20total_count%20from%20link_stat%20where%20url%20=%20'http%253A%252F%252Flink.springer.com%252Farticle%252F10.1007%252Fs00520-014-2328-7'
## 6                                                                                                                                                                                                                                                               the server responded with status 401 for http://dx.doi.org/10.1038/sc.2014.108
##   status     hostname
## 1     NA 78.46.96.241
## 2     NA 78.46.96.241
## 3     NA 78.46.96.241
## 4    404 78.46.96.241
## 5    400 78.46.96.241
## 6    401 78.46.96.241
##                                                                                                                                                                                                                                                                                            target_url
## 1                                                                                                                                                                                                                                                                                                <NA>
## 2                                                                                                                                                                                                                                                                                                <NA>
## 3                                                                                                                                                                                                                                                                                                <NA>
## 4                                                                                                                                                                                                                                                             http://pubs.acs.org/action/cookieabsent
## 5 https://graph.facebook.com/fql?access_token=cbe96f83275b52989a2a70cdefe35712&q=select%20url,%20share_count,%20like_count,%20comment_count,%20click_count,%20total_count%20from%20link_stat%20where%20url%20=%20'http%253A%252F%252Flink.springer.com%252Farticle%252F10.1007%252Fs00520-014-2328-7'
## 6                                                                                                                                                                                                                                                               http://dx.doi.org/10.1038/sc.2014.108
##     source                   article unresolved          create_date
## 1     <NA>                      <NA>       TRUE 2014-09-20T18:00:09Z
## 2 facebook                      <NA>       TRUE 2014-09-20T14:00:49Z
## 3     <NA>                      <NA>       TRUE 2014-09-20T14:00:10Z
## 4     <NA>         10.1021/mp5002119       TRUE 2014-09-20T11:40:08Z
## 5 facebook 10.1007/s00520-014-2328-7       TRUE 2014-09-20T11:40:06Z
## 6     <NA>       10.1038/sc.2014.108       TRUE 2014-09-20T11:40:03Z
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

### Other sources

I'll add exmaples of working with other data sources as they come online. E.g., eLife and PKP are using the ALM app, but are using an older version that doesn't support the alerts data.
