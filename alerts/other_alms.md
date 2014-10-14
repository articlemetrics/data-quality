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
##      id level    class_name
## 1 57637 ERROR StandardError
## 2 57638 ERROR StandardError
## 3 57636 ERROR StandardError
## 4 57635 ERROR StandardError
## 5 57634 ERROR StandardError
## 6 57633 ERROR StandardError
##                                                                       message
## 1  Error monitoring workers, only 9 of 25 workers running. Workers restarted.
## 2  Error monitoring workers, only 9 of 25 workers running. Workers restarted.
## 3 Error monitoring workers, only 24 of 25 workers running. Workers restarted.
## 4 Error monitoring workers, only 24 of 25 workers running. Workers restarted.
## 5 Error monitoring workers, only 24 of 25 workers running. Workers restarted.
## 6 Error monitoring workers, only 24 of 25 workers running. Workers restarted.
##   status     hostname target_url source article unresolved
## 1     NA 78.46.96.241       <NA>     NA      NA       TRUE
## 2     NA 78.46.96.241       <NA>     NA      NA       TRUE
## 3     NA 78.46.96.241       <NA>     NA      NA       TRUE
## 4     NA 78.46.96.241       <NA>     NA      NA       TRUE
## 5     NA 78.46.96.241       <NA>     NA      NA       TRUE
## 6     NA 78.46.96.241       <NA>     NA      NA       TRUE
##            create_date
## 1 2014-10-13T22:00:17Z
## 2 2014-10-13T22:00:17Z
## 3 2014-10-13T18:00:18Z
## 4 2014-10-13T18:00:16Z
## 5 2014-10-13T14:00:16Z
## 6 2014-10-13T14:00:15Z
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
##       id level                class_name
## 1 224049 FATAL Faraday::ResourceNotFound
## 2 224048 ERROR Faraday::ResourceNotFound
## 3 224047 ERROR             StandardError
## 4 224046 ERROR           DelayedJobError
## 5 224045 ERROR           DelayedJobError
## 6 224044 ERROR           DelayedJobError
##                                                                                                                                                                                          message
## 1                                                                                                                                            DOI 10.1365/s35173-011-0163-4 could not be resolved
## 2 Canonical URL mismatch: http://journals.cambridge.org/abstract_s0075435800046943 for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=8421387&fileid=s0075435800046943
## 3                                                                                                                     Error monitoring workers, only 3 of 10 workers running. Workers restarted.
## 4                                                                                                                                    Failure in wordpress: Wordpress.com is not in working state
## 5                                                                                                                                    Failure in wordpress: Wordpress.com is not in working state
## 6                                                                                                                                    Failure in wordpress: Wordpress.com is not in working state
##   status             hostname
## 1    404 labs.crowdometer.org
## 2    404 labs.crowdometer.org
## 3     NA labs.crowdometer.org
## 4     NA labs.crowdometer.org
## 5     NA labs.crowdometer.org
## 6     NA labs.crowdometer.org
##                                                                                                  target_url
## 1                                                                                  http://link.springer.com
## 2 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=8421387&fileid=s0075435800046943
## 3                                                                                                      <NA>
## 4                                                                                                      <NA>
## 5                                                                                                      <NA>
## 6                                                                                                      <NA>
##      source                   article unresolved          create_date
## 1      <NA> 10.1365/s35173-011-0163-4       TRUE 2014-10-14T01:00:40Z
## 2      <NA>            10.2307/295613       TRUE 2014-10-14T01:00:33Z
## 3      <NA>                      <NA>       TRUE 2014-10-14T01:00:06Z
## 4 wordpress                      <NA>       TRUE 2014-10-14T00:44:41Z
## 5 wordpress                      <NA>       TRUE 2014-10-14T00:44:41Z
## 6 wordpress                      <NA>       TRUE 2014-10-14T00:44:41Z
```

### PKP

> This doesn't seem to be working...


```r
url <- 'http://pkp-alm.lib.sfu.ca/api/v4/alerts'
user <- 'myrmecocystus@gmail.com'
pwd <- getOption('pkpalmkey')
res <- alm_alerts(url = url, user = user, pwd = pwd)
head(res$data)
```

### Pensoft

> This is not for alerts data, just regular ALM data, but just to demonstrate using the Pensoft API.


```r
url <- 'http://alm.pensoft.net:81/api/v5/articles'
key <- getOption('pensoftalmkey')
alm_ids(doi = "10.3897/zookeys.88.807", url = url, key = key)
```

```
## $meta
##   total total_pages page error
## 1     1           1    1    NA
## 
## $data
##               .id pdf html readers comments likes total
## 1        facebook  NA   NA      NA       NA    NA     0
## 2      copernicus   0    0      NA       NA    NA     0
## 3       wikipedia  NA   NA      NA       NA    NA   136
## 4          nature  NA   NA      NA       NA    NA     0
## 5       citeulike  NA   NA       1       NA    NA     1
## 6        crossref  NA   NA      NA       NA    NA    81
## 7        datacite  NA   NA      NA       NA    NA     0
## 8   pmceuropedata  NA   NA      NA       NA    NA     0
## 9          pubmed  NA   NA      NA       NA    NA    51
## 10          f1000  NA   NA      NA       NA    NA     0
## 11         scopus  NA   NA      NA       NA    NA   176
## 12       figshare  NA   NA      NA       NA    NA     0
## 13        counter  NA   NA      NA       NA    NA     0
## 14       mendeley  NA   NA     123       NA    NA   123
## 15         reddit  NA   NA      NA        0     0     0
## 16 twitter_search  NA   NA      NA        0    NA     0
## 17      wordpress  NA   NA      NA       NA    NA     0
## 18      pmceurope  NA   NA      NA       NA    NA    52
```


### Other sources

I'll add exmaples of working with other data sources as they come online. 
