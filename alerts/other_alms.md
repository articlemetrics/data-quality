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
## 1 11762  WARN Net::HTTPRequestTimeOut
## 2 11761  WARN Net::HTTPRequestTimeOut
## 3 11760  WARN Net::HTTPRequestTimeOut
## 4 11759  WARN Net::HTTPRequestTimeOut
## 5 11758 ERROR           StandardError
## 6 11757 ERROR           StandardError
##                                                                                                                                                                                                                             message
## 1               request timed out for http://sv.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%2210.1002%2F9781118351222.wbegt4160%22&srnamespace=0&srwhat=text&srinfo=totalhits&srprop=timestamp&srlimit=1
## 2 request timed out for http://fr.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%2210.1093%2Facprof%3Aoso%2F9780199985388.003.0006%22&srnamespace=0&srwhat=text&srinfo=totalhits&srprop=timestamp&srlimit=1
## 3                       request timed out for http://sv.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%2210.1109%2Ffg.2013.6553772%22&srnamespace=0&srwhat=text&srinfo=totalhits&srprop=timestamp&srlimit=1
## 4                     request timed out for http://sv.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%2210.1109%2Fccdc.2013.6561864%22&srnamespace=0&srwhat=text&srinfo=totalhits&srprop=timestamp&srlimit=1
## 5                                                                                                                                                        Error monitoring workers, only 1 of 25 workers running. Workers restarted.
## 6                                                                                                                                                        Error monitoring workers, only 1 of 25 workers running. Workers restarted.
##   status     hostname
## 1    408 78.46.96.241
## 2    408 78.46.96.241
## 3    408 78.46.96.241
## 4    408 78.46.96.241
## 5     NA 78.46.96.241
## 6     NA 78.46.96.241
##                                                                                                                                                                                                    target_url
## 1               http://sv.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%2210.1002%2F9781118351222.wbegt4160%22&srnamespace=0&srwhat=text&srinfo=totalhits&srprop=timestamp&srlimit=1
## 2 http://fr.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%2210.1093%2Facprof%3Aoso%2F9780199985388.003.0006%22&srnamespace=0&srwhat=text&srinfo=totalhits&srprop=timestamp&srlimit=1
## 3                       http://sv.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%2210.1109%2Ffg.2013.6553772%22&srnamespace=0&srwhat=text&srinfo=totalhits&srprop=timestamp&srlimit=1
## 4                     http://sv.wikipedia.org/w/api.php?action=query&list=search&format=json&srsearch=%2210.1109%2Fccdc.2013.6561864%22&srnamespace=0&srwhat=text&srinfo=totalhits&srprop=timestamp&srlimit=1
## 5                                                                                                                                                                                                        <NA>
## 6                                                                                                                                                                                                        <NA>
##      source                                   article unresolved
## 1 wikipedia           10.1002/9781118351222.wbegt4160       TRUE
## 2 wikipedia 10.1093/acprof:oso/9780199985388.003.0006       TRUE
## 3 wikipedia                   10.1109/fg.2013.6553772       TRUE
## 4 wikipedia                 10.1109/ccdc.2013.6561864       TRUE
## 5      <NA>                                      <NA>       TRUE
## 6      <NA>                                      <NA>       TRUE
##            create_date
## 1 2014-09-09T18:30:58Z
## 2 2014-09-09T16:30:59Z
## 3 2014-09-09T13:40:50Z
## 4 2014-09-09T12:09:14Z
## 5 2014-09-09T10:00:10Z
## 6 2014-09-09T06:00:09Z
```

### PLOS Labs ALM


```r
url <- "http://labs.crowdometer.org/api/v4/alerts"
user <- getOption('almv4_ploslabs_user')
pwd <- getOption('almv4_ploslabs_pwd')
res <- alm_alerts(url = url, user = user, pwd = pwd)
head(res$data)
```

```
##      id level      class_name
## 1 55593 FATAL DelayedJobError
## 2 55594 FATAL DelayedJobError
## 3 55595 FATAL DelayedJobError
## 4 55585 FATAL DelayedJobError
## 5 55586 FATAL DelayedJobError
## 6 55587 FATAL DelayedJobError
##                                             message status
## 1 Failure in reddit: Reddit is not in working state     NA
## 2 Failure in reddit: Reddit is not in working state     NA
## 3 Failure in reddit: Reddit is not in working state     NA
## 4 Failure in reddit: Reddit is not in working state     NA
## 5 Failure in reddit: Reddit is not in working state     NA
## 6 Failure in reddit: Reddit is not in working state     NA
##               hostname target_url source article unresolved
## 1 labs.crowdometer.org         NA reddit      NA       TRUE
## 2 labs.crowdometer.org         NA reddit      NA       TRUE
## 3 labs.crowdometer.org         NA reddit      NA       TRUE
## 4 labs.crowdometer.org         NA reddit      NA       TRUE
## 5 labs.crowdometer.org         NA reddit      NA       TRUE
## 6 labs.crowdometer.org         NA reddit      NA       TRUE
##            create_date
## 1 2014-09-09T18:44:54Z
## 2 2014-09-09T18:44:54Z
## 3 2014-09-09T18:44:54Z
## 4 2014-09-09T18:44:53Z
## 5 2014-09-09T18:44:53Z
## 6 2014-09-09T18:44:53Z
```

