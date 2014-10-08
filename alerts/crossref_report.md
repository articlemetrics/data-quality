Crossref Report
========================================================



### Date 

Compiled on 2014-10-07 19:17:03

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
## Source: local data frame [5,292 x 8]
## 
##       id level                  class_name                      article
## 1  49206 ERROR ActiveRecord::RecordInvalid                           NA
## 2  49207 ERROR ActiveRecord::RecordInvalid                           NA
## 3  49205 ERROR ActiveRecord::RecordInvalid                           NA
## 4  49204 ERROR ActiveRecord::RecordInvalid                           NA
## 5  49203 ERROR               StandardError                           NA
## 6  49202 ERROR               StandardError                           NA
## 7  49201  WARN Net::HTTPServiceUnavailable 10.1080/1551806x.2014.897883
## 8  49198  WARN     Net::HTTPRequestTimeOut                           NA
## 9  49199  WARN     Net::HTTPRequestTimeOut                           NA
## 10 49200  WARN     Net::HTTPRequestTimeOut                           NA
## ..   ...   ...                         ...                          ...
## Variables not shown: status (dbl), source (chr), create_date (chr),
##   target_url (chr)
```

### Visual exploration of alerts

#### type of alerts


```r
library(ggplot2)
resdf %>%
  group_by(class_name) %>%
  summarise(number = length(class_name)) %>%
  ggplot(aes(reorder(class_name, number), number)) +
    geom_histogram(stat = "identity") + 
    coord_flip() +
    theme_grey(base_size = 20) +
    labs(x = "Alert", y = "No. Articles")
```

![plot of chunk alerttypes](figure/alerttypes.png) 

#### alerts by source

By source alone


```r
resdf %>%
  group_by(source) %>%
  summarise(number = length(source)) %>%
  ggplot(aes(reorder(source, number), number)) +
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
  summarise(number = length(source)) %>%
  ggplot(aes(reorder(source, number), number)) +
    geom_histogram(stat = "identity") + 
#     coord_flip() +
    theme_grey(base_size = 20) +
    facet_wrap(~ class_name, scales="free") +
    labs(x = "Source", y = "No. Articles")
```

![plot of chunk sourcebyclass](figure/sourcebyclass.png) 

