Crossref Report
========================================================



### Date 

Compiled on 2014-10-16 10:41:25

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



### Set up variables


```r
url <- "http://det.labs.crossref.org/api/v4/alerts"
user <- getOption('almv4_crossref_user')
pwd <- getOption('almv4_crossref_pwd')
cr_v5_key <- getOption('crossrefalmkey')
```

### Get all data


```r
meta <- alm_alerts(url = url, user = user, pwd = pwd)$meta
res <- lapply(1:meta$total_pages, function(x) alm_alerts(page=x, url=url, user=user, pwd=pwd))
(resdf <- do.call(rbind, lapply(res, "[[", "data")) %>% 
   tbl_df %>% 
   select(id, level, class_name, article, status, source, create_date, target_url))
```

```
## Source: local data frame [13,725 x 8]
## 
##       id level    class_name article status source          create_date target_url
## 1  57640 ERROR StandardError      NA     NA     NA 2014-10-14T02:00:13Z         NA
## 2  57639 ERROR StandardError      NA     NA     NA 2014-10-14T02:00:10Z         NA
## 3  57638 ERROR StandardError      NA     NA     NA 2014-10-13T22:00:17Z         NA
## 4  57637 ERROR StandardError      NA     NA     NA 2014-10-13T22:00:17Z         NA
## 5  57636 ERROR StandardError      NA     NA     NA 2014-10-13T18:00:18Z         NA
## 6  57635 ERROR StandardError      NA     NA     NA 2014-10-13T18:00:16Z         NA
## 7  57634 ERROR StandardError      NA     NA     NA 2014-10-13T14:00:16Z         NA
## 8  57633 ERROR StandardError      NA     NA     NA 2014-10-13T14:00:15Z         NA
## 9  57632 ERROR StandardError      NA     NA     NA 2014-10-13T10:00:15Z         NA
## 10 57631 ERROR StandardError      NA     NA     NA 2014-10-13T10:00:15Z         NA
## ..   ...   ...           ...     ...    ...    ...                  ...        ...
```

### Types of errors


```r
tabl <- resdf %>%
  group_by(class_name) %>%
  summarise(n = n()) %>%
  arrange(desc(n))

kable(tabl, format = "markdown")
```



|class_name                              |    n|
|:---------------------------------------|----:|
|ActiveRecord::RecordInvalid             | 6916|
|Net::HTTPForbidden                      | 2260|
|Net::HTTPServiceUnavailable             | 1153|
|Faraday::ResourceNotFound               | 1005|
|Net::HTTPBadGateway                     |  545|
|Net::HTTPConflict                       |  544|
|Net::HTTPRequestTimeOut                 |  386|
|Faraday::ClientError                    |  285|
|ActiveRecord::StatementInvalid          |  197|
|Net::HTTPNotAcceptable                  |  166|
|Net::HTTPInternalServerError            |   79|
|Net::HTTPUnauthorized                   |   79|
|StandardError                           |   61|
|FaradayMiddleware::RedirectLimitReached |   21|
|Errno::EACCES                           |   17|
|Net::HTTPBadRequest                     |    6|
|TooManyErrorsBySourceError              |    3|
|ActionView::Template::Error             |    2|


### Alerts by source

By source alone

> NOTE: the NA's are not mistakes, but what is given as the source


```r
resdf %>%
  group_by(source) %>%
  summarise(n = n()) %>%
  ggplot(aes(reorder(source, n), n)) +
    geom_histogram(stat = "identity") + 
    coord_flip() +
    theme_grey(base_size = 20) +
    labs(x = "Source", y = "No. Articles")
```

![plot of chunk bysource](figure/bysource.png) 

source X alert class


```r
resdf %>%
  group_by(source, class_name) %>%
  summarise(n = n()) %>%
  ggplot(aes(reorder(class_name, n), n, fill=source)) +
    geom_histogram(stat = "identity") + 
    coord_flip() +
    theme_grey(base_size = 20) +
    labs(x = "Source", y = "No. Articles") +
    theme(legend.position = "top")
```

![plot of chunk sourcebyclass](figure/sourcebyclass.png) 

### Dig into Net::HTTPForbidden errors


```r
library('httr')
library('jsonlite')
```

```
## 
## Attaching package: 'jsonlite'
## 
## The following object is masked from 'package:utils':
## 
##     View
```

```r
res <- GET('http://det.labs.crossref.org/api/v5/publishers', query=list(api_key=cr_v5_key))
prefixes <- fromJSON(content(res, "text"))$data[,c('name','prefixes')]
pre <- prefixes$prefixes
names(pre) <- prefixes$name
```

Define functions


```r
splitdoi <- function(x) strsplit(x, "/")[[1]][[1]]
match_publisher <- function(x, y){
  names(y[ sapply(y, function(z) x %in% z) ])
}
```

Manipulate data


```r
# subset data
dat <- resdf %>%
  filter(class_name == "Net::HTTPForbidden") %>%
  mutate(prefix = splitdoi(article)) %>%
  select(id, level, class_name, article, prefix, status, source, create_date, target_url)

# get publishers
pubs <- dat %>%
  rowwise %>%
  do( publisher = match_publisher(.$prefix, pre) )

# join the two data.frame's
alldf <- tbl_df(cbind(dat, pubs))
alldf$publisher <- as.character(alldf$publisher)
unique(alldf$publisher)
```

```
## [1] "Wiley-Blackwell"
```

> Note: All `Net::HTTPForbidden` are from Wiley, trying to get Wikipedia data source
