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
##      id level                  class_name
## 1 57664 ERROR               StandardError
## 2 57663 ERROR               StandardError
## 3 57662 ERROR           Net::HTTPConflict
## 4 57661 ERROR               StandardError
## 5 57660 ERROR               StandardError
## 6 57659 ERROR ActiveRecord::RecordInvalid
##                                                                                                          message
## 1                                     Error monitoring workers, only 0 of 25 workers running. Workers restarted.
## 2                                     Error monitoring workers, only 0 of 25 workers running. Workers restarted.
## 3 the server responded with status 409 for http://144.76.226.211:5984/alm/datacite:10.1021%2Fol202527g with rev 
## 4                                     Error monitoring workers, only 0 of 25 workers running. Workers restarted.
## 5                                    Error monitoring workers, only 24 of 25 workers running. Workers restarted.
## 6                                           Validation failed: Title can't be blank for doi 10.1098/rsos.140249.
##   status     hostname
## 1     NA 78.46.96.241
## 2     NA 78.46.96.241
## 3    409 78.46.96.241
## 4     NA 78.46.96.241
## 5     NA 78.46.96.241
## 6     NA 78.46.96.241
##                                                    target_url   source
## 1                                                        <NA>     <NA>
## 2                                                        <NA>     <NA>
## 3 http://144.76.226.211:5984/alm/datacite:10.1021%2Fol202527g datacite
## 4                                                        <NA>     <NA>
## 5                                                        <NA>     <NA>
## 6           http://api.crossref.org/works/10.1098/rsos.140249     <NA>
##   article unresolved          create_date
## 1      NA       TRUE 2014-10-21T00:00:09Z
## 2      NA      FALSE 2014-10-20T00:00:10Z
## 3      NA      FALSE 2014-10-19T10:28:30Z
## 4      NA      FALSE 2014-10-19T00:00:09Z
## 5      NA      FALSE 2014-10-18T07:00:13Z
## 6      NA       TRUE 2014-10-18T00:05:20Z
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
## 1 259365 ERROR     Net::HTTPUnauthorized
## 2 259364 ERROR Faraday::ResourceNotFound
## 3 259363 ERROR Faraday::ResourceNotFound
## 4 259362 ERROR Faraday::ResourceNotFound
## 5 259361 ERROR Faraday::ResourceNotFound
## 6 259360 ERROR Faraday::ResourceNotFound
##                                                                                                                                                                                                          message
## 1                                                                                                                                     the server responded with status 401 for http://dx.doi.org/10.1038/469447a
## 2 Canonical URL mismatch: /journal/3/174-essential-considerations-in-the-investigation-of-associations-between-insulin-and-cancer-risk-using-prescription-databases.php for http://ecancer.org/journal/3/174.php
## 3                                  Canonical URL mismatch: /journal/3/153-oxaliplatin-pre-clinical-perspectives-on-the-mechanisms-of-action-response-and-resistance.php for http://ecancer.org/journal/3/153.php
## 4                 Canonical URL mismatch: http://journals.cambridge.org/abstract_s088376940001592x for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7962205&fileid=s088376940001592x
## 5                 Canonical URL mismatch: http://journals.cambridge.org/abstract_s003871340012113x for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7683468&fileid=s003871340012113x
## 6                 Canonical URL mismatch: http://journals.cambridge.org/abstract_s1946427400120779 for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=8021404&fileid=s1946427400120779
##   status             hostname
## 1    401 labs.crowdometer.org
## 2    404 labs.crowdometer.org
## 3    404 labs.crowdometer.org
## 4    404 labs.crowdometer.org
## 5    404 labs.crowdometer.org
## 6    404 labs.crowdometer.org
##                                                                                                  target_url
## 1                                                                         http://dx.doi.org/10.1038/469447a
## 2                                                                      http://ecancer.org/journal/3/174.php
## 3                                                                      http://ecancer.org/journal/3/153.php
## 4 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7962205&fileid=s088376940001592x
## 5 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7683468&fileid=s003871340012113x
## 6 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=8021404&fileid=s1946427400120779
##   source                   article unresolved          create_date
## 1   <NA>           10.1038/469447a       TRUE 2014-10-21T17:01:03Z
## 2   <NA>  10.3332/ecancer.2009.174       TRUE 2014-10-21T17:00:46Z
## 3   <NA>  10.3332/ecancer.2009.153       TRUE 2014-10-21T17:00:38Z
## 4   <NA>       10.1557/mrs2004.151       TRUE 2014-10-21T17:00:34Z
## 5   <NA> 10.1017/s003871340012113x       TRUE 2014-10-21T17:00:33Z
## 6   <NA>  10.1557/PROC-0900-O12-33       TRUE 2014-10-21T17:00:32Z
```

### PKP


```r
url <- 'http://pkp-alm.lib.sfu.ca/api/v4/alerts'
user <- getOption('almv4_pkp_user')
pwd <- getOption('almv4_pkp_pwd')
res <- alm_alerts(url = url, user = user, pwd = pwd)
head(res$data)
```

```
##        id level      class_name
## 1 1603800 ERROR DelayedJobError
## 2 1603799 ERROR DelayedJobError
## 3 1603798 ERROR DelayedJobError
## 4 1603797 ERROR DelayedJobError
## 5 1603796 ERROR DelayedJobError
## 6 1603795 ERROR DelayedJobError
##                                                                   message
## 1 Failure in twitter_search: Twitter (Search API) is not in working state
## 2 Failure in twitter_search: Twitter (Search API) is not in working state
## 3 Failure in twitter_search: Twitter (Search API) is not in working state
## 4 Failure in twitter_search: Twitter (Search API) is not in working state
## 5 Failure in twitter_search: Twitter (Search API) is not in working state
## 6 Failure in twitter_search: Twitter (Search API) is not in working state
##   status                  hostname target_url         source article
## 1     NA http://pkp-alm.lib.sfu.ca         NA twitter_search      NA
## 2     NA http://pkp-alm.lib.sfu.ca         NA twitter_search      NA
## 3     NA http://pkp-alm.lib.sfu.ca         NA twitter_search      NA
## 4     NA http://pkp-alm.lib.sfu.ca         NA twitter_search      NA
## 5     NA http://pkp-alm.lib.sfu.ca         NA twitter_search      NA
## 6     NA http://pkp-alm.lib.sfu.ca         NA twitter_search      NA
##   unresolved          create_date
## 1       TRUE 2014-10-21T17:35:27Z
## 2       TRUE 2014-10-21T17:35:15Z
## 3       TRUE 2014-10-21T17:35:03Z
## 4       TRUE 2014-10-21T17:34:47Z
## 5       TRUE 2014-10-21T17:34:23Z
## 6       TRUE 2014-10-21T17:33:39Z
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
