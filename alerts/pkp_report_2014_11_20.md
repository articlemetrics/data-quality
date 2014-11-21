PKP Report
========================================================



### Date 

Compiled on 2014-11-20 18:36:53

### Setup

> change directory to /data-quality/alerts


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


```r
knitr::purl("alertssetup.Rmd")
source("alertssetup.R")
unlink("alertssetup.R")
```

### Set up variables


```r
url <- 'http://pkp-alm.lib.sfu.ca/api/v4/alerts'
user <- getOption('almv4_pkp_user')
pwd <- getOption('almv4_pkp_pwd')
pkp_v5_key <- getOption('pkpalmkey')
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
## Source: local data frame [32,097 x 8]
## 
##         id level                  class_name                   article
## 1  1642738  WARN Net::HTTPServiceUnavailable    10.4314/nvj.v29i1.3577
## 2  1642735  WARN Net::HTTPServiceUnavailable   10.4314/acsj.v9i1.27638
## 3  1642736  WARN Net::HTTPServiceUnavailable   10.4314/njm.v16i4.37345
## 4  1642737  WARN Net::HTTPServiceUnavailable  10.4314/njhbs.v7i2.11668
## 5  1642732  WARN Net::HTTPServiceUnavailable    10.4314/njhs.v8i1.3354
## 6  1642733  WARN Net::HTTPServiceUnavailable  10.4314/njhbs.v5i2.11600
## 7  1642734  WARN Net::HTTPServiceUnavailable   10.4314/njpr.v3i1.35388
## 8  1642731  WARN Net::HTTPServiceUnavailable 10.4314/njpar.v27i1.37841
## 9  1642730 ERROR               StandardError                        NA
## 10 1642729  WARN Net::HTTPServiceUnavailable   10.4314/tjs.v31i1.18408
## ..     ...   ...                         ...                       ...
## Variables not shown: status (int), source (chr), create_date (chr),
##   target_url (chr)
```

### Types of errors


```r
tabl <- resdf %>%
  group_by(class_name) %>%
  summarise(n = n()) %>%
  arrange(desc(n))

kable(tabl, format = "markdown")
```



|class_name                     |     n|
|:------------------------------|-----:|
|Net::HTTPForbidden             | 13604|
|Net::HTTPClientError           | 10124|
|DelayedJobError                |  3379|
|Net::HTTPServiceUnavailable    |  2685|
|Faraday::ResourceNotFound      |  1327|
|Net::HTTPInternalServerError   |   324|
|Net::HTTPNotAcceptable         |   201|
|Net::HTTPRequestTimeOut        |   142|
|Net::HTTPConflict              |    89|
|StandardError                  |    76|
|TooManyErrorsBySourceError     |    52|
|Net::HTTPBadRequest            |    51|
|ActiveRecord::RecordInvalid    |    14|
|ActiveRecord::StatementInvalid |    11|
|NoMethodError                  |    11|
|Net::HTTPBadGateway            |     5|
|ActionView::MissingTemplate    |     2|

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

![plot of chunk bysource](figure/bysource-1.png) 

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

![plot of chunk sourcebyclass](figure/sourcebyclass-1.png) 

### Define functions


```r
library('rcrossref')

splitdoi <- function(x) strsplit(x, "/")[[1]][[1]]

match_publisher <- function(x, y){
  names(y[ sapply(y, function(z) x %in% z) ])
}

table_summary <- function(x){  
  rr <- x %>%
    group_by(publisher) %>%
    summarise(n = n()) %>%
    arrange(desc(n))
  kable(na.omit(rr[1:10,]), format = "markdown")
}

get_prefixes <- function(x){
  uniqpre <- na.omit(unique(x))
  cr_prefixes(uniqpre)$data %>%
    rowwise %>%
    mutate(prefix_ = strsplit(sub("http://id.crossref.org/prefix/", "", prefix), "/")[[1]][[1]]) %>%
    select(-member, -prefix)
}
```

### Net::HTTPClient errors


```r
dat <- resdf %>%
  filter(class_name == "Net::HTTPClientError") %>%
  select(id, level, class_name, article, status, source, create_date, target_url) %>%
  rowwise %>%
  mutate(prefix_ = strsplit(article, "/")[[1]][[1]])

pre_resdf <- get_prefixes(dat$prefix_)

nethttpclient <- inner_join(dat, pre_resdf, "prefix_") %>%
  select(-article, -status, -source) %>%
  rename(prefix = prefix_, publisher = name)
table_summary(nethttpclient)
```



|publisher                                                            |    n|
|:--------------------------------------------------------------------|----:|
|African Journals Online (AJOL)                                       | 4898|
|PAGEPress Publications                                               | 1250|
|Universidade de Sao Paulo Sistema Integrado de Bibliotecas - SIBiUSP |  937|
|Co-Action Publishing                                                 |  552|
|Universidad de Costa Rica                                            |  419|
|Polish Botanical Society                                             |  407|
|Nepal Journals Online (JOL)                                          |  335|
|Editora Cubo Multimidia                                              |  241|
|American Academy of Implant Dentistry                                |  214|
|Universidade Federal de Santa Catarina (UFSC)                        |  207|

### Net::HTTPForbidden errors


```r
dat <- resdf %>%
  filter(class_name == "Net::HTTPForbidden") %>%
  select(id, level, class_name, article, status, source, create_date, target_url) %>%
  rowwise %>%
  mutate(prefix_ = strsplit(article, "/")[[1]][[1]])

pre_resdf <- get_prefixes(dat$prefix_)

nethttpforbidden <- inner_join(dat, pre_resdf, "prefix_") %>%
  select(-article, -status, -source) %>%
  rename(prefix = prefix_, publisher = name)
table_summary(nethttpforbidden)
```



|publisher                                                            |    n|
|:--------------------------------------------------------------------|----:|
|African Journals Online (AJOL)                                       | 4982|
|Universidade de Sao Paulo Sistema Integrado de Bibliotecas - SIBiUSP | 1858|
|Co-Action Publishing                                                 | 1213|
|American Academy of Implant Dentistry                                | 1210|
|Universidade Federal de Santa Catarina (UFSC)                        |  762|
|Nepal Journals Online (JOL)                                          |  742|
|Sri Lanka Journals Online (JOL)                                      |  536|
|Universidad de Costa Rica                                            |  526|
|Wiley-Blackwell                                                      |  456|
|Polish Botanical Society                                             |  296|

### Net::HTTPRequestTimeOut errors


```r
dat <- resdf %>%
  filter(class_name == "Net::HTTPRequestTimeOut") %>%
  select(id, level, class_name, article, status, source, create_date, target_url) %>%
  rowwise %>%
  mutate(prefix_ = str_extract(target_url, "10\\.[0-9]+"))

pre_resdf <- get_prefixes(dat$prefix_)

nethttprequesttimeout <- inner_join(dat, pre_resdf, "prefix_") %>%
  select(-article, -status, -source) %>%
  rename(prefix = prefix_, publisher = name)
table_summary(nethttprequesttimeout)
```



|publisher                                                            |  n|
|:--------------------------------------------------------------------|--:|
|Bangladesh Journals Online (JOL)                                     | 47|
|African Journals Online (AJOL)                                       | 24|
|Universidade de Sao Paulo Sistema Integrado de Bibliotecas - SIBiUSP | 18|
|Wiley-Blackwell                                                      | 12|
|Co-Action Publishing                                                 | 10|
|Vietnam Journals Online (JOL)                                        |  6|
|Zeppelini Editorial e Comunicacao                                    |  5|
|FapUNIFESP (SciELO)                                                  |  4|
|Universidad de Costa Rica                                            |  3|
|Universidade Federal de Santa Catarina (UFSC)                        |  3|

### ActiveRecord::RecordInvalid errors


```r
dat <- resdf %>%
  filter(class_name == "ActiveRecord::RecordInvalid") %>%
  select(id, level, class_name, article, status, source, create_date, target_url) %>%
  rowwise %>%
  mutate(prefix_ = strsplit(sub("http://api.crossref.org/works/", "", target_url), "/")[[1]][[1]])

pre_resdf <- get_prefixes(
  sapply(dat$target_url, function(x) strsplit(sub("http://api\\.crossref\\.org/works/", "", x), "/")[[1]][[1]], USE.NAMES = FALSE)
)

activerecord <- inner_join(dat, pre_resdf, "prefix_") %>%
  select(-article, -status, -source) %>%
  rename(prefix = prefix_, publisher = name)
table_summary(activerecord)
```



|publisher                                     |  n|
|:---------------------------------------------|--:|
|Education Policy Analysis Archives            |  6|
|Elsevier BV                                   |  6|
|Universidade Federal de Santa Catarina (UFSC) |  2|

### Net::HTTPServiceUnavailable errors


```r
dat <- resdf %>%
  filter(class_name == "Net::HTTPServiceUnavailable") %>%
  select(id, level, class_name, article, status, source, create_date, target_url) %>%
  rowwise %>%
  mutate(prefix_ = str_extract(target_url, "10\\.[0-9]+"))

pre_resdf <- get_prefixes(dat$prefix_)

nethttserviceun <- inner_join(dat, pre_resdf, "prefix_") %>%
  select(-article, -status, -source) %>%
  rename(prefix = prefix_, publisher = name)
table_summary(nethttserviceun)
```



|publisher                                                            |    n|
|:--------------------------------------------------------------------|----:|
|African Journals Online (AJOL)                                       | 1575|
|Universidade Federal de Santa Catarina (UFSC)                        |  265|
|Wiley-Blackwell                                                      |  208|
|Universidade de Sao Paulo Sistema Integrado de Bibliotecas - SIBiUSP |  148|
|Co-Action Publishing                                                 |  104|
|Editora Cubo Multimidia                                              |   78|
|Latin America Journals Online                                        |   65|
|FapUNIFESP (SciELO)                                                  |   63|
|Informa UK Limited                                                   |   35|
|Informa Healthcare                                                   |   20|

### The rest of the errors


```r
other <- 
  resdf %>% filter(class_name %in% c("Net::HTTPBadGateway","StandardError","TooManyErrorsBySourceError","Net::HTTPNotAcceptable","Faraday::ResourceNotFound","ActionView::MissingTemplate","Faraday::ClientError"))
```

### Write files out


```r
write_csv <- function(x){
  write.csv(get(x), file=sprintf("pkp_files/%s_error_%s.csv", x, Sys.Date()),
            row.names=FALSE)
}

write_csv('nethttpclient')
write_csv("nethttpforbidden")
write_csv("nethttprequesttimeout")
write_csv('activerecord')
write_csv('nethttserviceun')
write_csv('other')
```
