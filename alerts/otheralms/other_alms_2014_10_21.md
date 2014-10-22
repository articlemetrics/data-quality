other ALM sources
========================================================


### Date 

Compiled on 2014-10-21 19:05:39

### Setup

> change directory to /data-quality/alerts/


Install `alm` if not installed already, then load package


```r
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
##      id level        class_name
## 1 57666 ERROR     StandardError
## 2 57665 ERROR     StandardError
## 3 57664 ERROR     StandardError
## 4 57663 ERROR     StandardError
## 5 57662 ERROR Net::HTTPConflict
## 6 57661 ERROR     StandardError
##                                                                                                          message
## 1                                     Error monitoring workers, only 0 of 25 workers running. Workers restarted.
## 2                                    Error monitoring workers, only 21 of 25 workers running. Workers restarted.
## 3                                     Error monitoring workers, only 0 of 25 workers running. Workers restarted.
## 4                                     Error monitoring workers, only 0 of 25 workers running. Workers restarted.
## 5 the server responded with status 409 for http://144.76.226.211:5984/alm/datacite:10.1021%2Fol202527g with rev 
## 6                                     Error monitoring workers, only 0 of 25 workers running. Workers restarted.
##   status     hostname
## 1     NA 78.46.96.241
## 2     NA 78.46.96.241
## 3     NA 78.46.96.241
## 4     NA 78.46.96.241
## 5    409 78.46.96.241
## 6     NA 78.46.96.241
##                                                    target_url   source
## 1                                                        <NA>     <NA>
## 2                                                        <NA>     <NA>
## 3                                                        <NA>     <NA>
## 4                                                        <NA>     <NA>
## 5 http://144.76.226.211:5984/alm/datacite:10.1021%2Fol202527g datacite
## 6                                                        <NA>     <NA>
##   article unresolved          create_date
## 1      NA       TRUE 2014-10-22T00:00:09Z
## 2      NA       TRUE 2014-10-21T21:00:13Z
## 3      NA       TRUE 2014-10-21T00:00:09Z
## 4      NA      FALSE 2014-10-20T00:00:10Z
## 5      NA      FALSE 2014-10-19T10:28:30Z
## 6      NA      FALSE 2014-10-19T00:00:09Z
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
## 1 259847 ERROR Faraday::ResourceNotFound
## 2 259846 ERROR Faraday::ResourceNotFound
## 3 259845 ERROR        Net::HTTPForbidden
## 4 259844 ERROR Faraday::ResourceNotFound
## 5 259843 ERROR Faraday::ResourceNotFound
## 6 259842 ERROR     Net::HTTPUnauthorized
##                                                                                                                                                                                          message
## 1 Canonical URL mismatch: http://journals.cambridge.org/abstract_s194642740051714x for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=8169549&fileid=s194642740051714x
## 2 Canonical URL mismatch: http://journals.cambridge.org/abstract_s0022046900072092 for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7804800&fileid=s0022046900072092
## 3                                                                                                          the server responded with status 403 for http://dx.doi.org/10.1164/rccm.201405-0850oc
## 4 Canonical URL mismatch: http://journals.cambridge.org/abstract_s0001972000079584 for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7897336&fileid=s0001972000079584
## 5                            Canonical URL mismatch: /journal/2/111-pegylated-liposomal-doxorubicin-pld-enhanced-skin-toxicity-in-areas-of-vitiligo.php for http://ecancer.org/journal/2/111.php
## 6                                                                                                   the server responded with status 401 for http://dx.doi.org/10.1038/scientificamerican0912-36
##   status             hostname
## 1    404 labs.crowdometer.org
## 2    404 labs.crowdometer.org
## 3    403 labs.crowdometer.org
## 4    404 labs.crowdometer.org
## 5    404 labs.crowdometer.org
## 6    401 labs.crowdometer.org
##                                                                                                  target_url
## 1 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=8169549&fileid=s194642740051714x
## 2 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7804800&fileid=s0022046900072092
## 3                                                              http://dx.doi.org/10.1164/rccm.201405-0850oc
## 4 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7897336&fileid=s0001972000079584
## 5                                                                      http://ecancer.org/journal/2/111.php
## 6                                                       http://dx.doi.org/10.1038/scientificamerican0912-36
##   source                           article unresolved          create_date
## 1   <NA>               10.1557/PROC-89-249       TRUE 2014-10-22T02:00:54Z
## 2   <NA>         10.1017/S0022046900072092       TRUE 2014-10-22T02:00:50Z
## 3   <NA>        10.1164/rccm.201405-0850oc       TRUE 2014-10-22T02:00:46Z
## 4   <NA>         10.1017/S0001972000079584       TRUE 2014-10-22T02:00:45Z
## 5   <NA>          10.3332/ecancer.2008.111       TRUE 2014-10-22T02:00:42Z
## 6   <NA> 10.1038/scientificamerican0912-36       TRUE 2014-10-22T02:00:39Z
```

### PKP


```r
url <- 'http://pkp-alm.lib.sfu.ca/api/v4/alerts'
user <- getOption('almv4_pkp_user')
pwd <- getOption('almv4_pkp_pwd')
res <- alm_alerts(url = url, user = user, pwd = pwd)
```

```
## Error in names(status) <- c("version", "status", "message"): 'names' attribute [3] must be the same length as the vector [2]
```

```r
head(res$data)
```

```
##       id level                class_name
## 1 259847 ERROR Faraday::ResourceNotFound
## 2 259846 ERROR Faraday::ResourceNotFound
## 3 259845 ERROR        Net::HTTPForbidden
## 4 259844 ERROR Faraday::ResourceNotFound
## 5 259843 ERROR Faraday::ResourceNotFound
## 6 259842 ERROR     Net::HTTPUnauthorized
##                                                                                                                                                                                          message
## 1 Canonical URL mismatch: http://journals.cambridge.org/abstract_s194642740051714x for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=8169549&fileid=s194642740051714x
## 2 Canonical URL mismatch: http://journals.cambridge.org/abstract_s0022046900072092 for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7804800&fileid=s0022046900072092
## 3                                                                                                          the server responded with status 403 for http://dx.doi.org/10.1164/rccm.201405-0850oc
## 4 Canonical URL mismatch: http://journals.cambridge.org/abstract_s0001972000079584 for http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7897336&fileid=s0001972000079584
## 5                            Canonical URL mismatch: /journal/2/111-pegylated-liposomal-doxorubicin-pld-enhanced-skin-toxicity-in-areas-of-vitiligo.php for http://ecancer.org/journal/2/111.php
## 6                                                                                                   the server responded with status 401 for http://dx.doi.org/10.1038/scientificamerican0912-36
##   status             hostname
## 1    404 labs.crowdometer.org
## 2    404 labs.crowdometer.org
## 3    403 labs.crowdometer.org
## 4    404 labs.crowdometer.org
## 5    404 labs.crowdometer.org
## 6    401 labs.crowdometer.org
##                                                                                                  target_url
## 1 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=8169549&fileid=s194642740051714x
## 2 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7804800&fileid=s0022046900072092
## 3                                                              http://dx.doi.org/10.1164/rccm.201405-0850oc
## 4 http://journals.cambridge.org/action/displayabstract?frompage=online&aid=7897336&fileid=s0001972000079584
## 5                                                                      http://ecancer.org/journal/2/111.php
## 6                                                       http://dx.doi.org/10.1038/scientificamerican0912-36
##   source                           article unresolved          create_date
## 1   <NA>               10.1557/PROC-89-249       TRUE 2014-10-22T02:00:54Z
## 2   <NA>         10.1017/S0022046900072092       TRUE 2014-10-22T02:00:50Z
## 3   <NA>        10.1164/rccm.201405-0850oc       TRUE 2014-10-22T02:00:46Z
## 4   <NA>         10.1017/S0001972000079584       TRUE 2014-10-22T02:00:45Z
## 5   <NA>          10.3332/ecancer.2008.111       TRUE 2014-10-22T02:00:42Z
## 6   <NA> 10.1038/scientificamerican0912-36       TRUE 2014-10-22T02:00:39Z
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
