EventCountDecreasingError
========================================================




### Date 

Compiled on 2014-10-21 19:37:25

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

### Get data


```r
(res <- alerts_by_class(class_name='EventCountDecreasingError', limit=5000L))
```

```
## Source: local data frame [137 x 8]
## 
##          id                      article val from to          create_date
## 1  12067284 10.1371/journal.pone.0080804  11   60 49 2014-10-14T08:06:52Z
## 2  12262540 10.1371/journal.pone.0069777   7   18 11 2014-10-18T08:29:48Z
## 3  12412558 10.1371/journal.pgen.1003996   4   12  8 2014-10-21T08:03:00Z
## 4  12412598 10.1371/journal.pone.0080122   3    8  5 2014-10-21T08:03:01Z
## 5  12412554 10.1371/journal.pone.0078259   3   11  8 2014-10-21T08:03:00Z
## 6  12262542 10.1371/journal.pone.0079452   3    3  0 2014-10-18T08:29:48Z
## 7  12171930 10.1371/journal.pone.0101787   3   10  7 2014-10-16T08:56:22Z
## 8  12120206 10.1371/journal.pone.0063143   3   39 36 2014-10-15T08:15:43Z
## 9  12412586 10.1371/journal.pone.0034199   2    6  4 2014-10-21T08:03:01Z
## 10 12412588 10.1371/journal.pone.0079841   2    6  4 2014-10-21T08:03:01Z
## ..      ...                          ... ...  ... ..                  ...
## Variables not shown: source (chr), class (chr)
```

Remove Mendeley data


```r
res <- res %>%
  filter(!source == "mendeley")
```

Clean out PLOS Currents urls


```r
res <- res %>% filter(grepl('journal', article))
res <- res %>% 
  rename(doi = article, alert_class = class, alert_source = source, alert_create_date = create_date, alert_id = id, alert_val = val, alert_from = from, alert_to = to)
```

Get ALM events data and merge alerts data to it


```r
# altmetrics totals data
idsdata <- alm_ids(res$doi)
almdat <- function(x, y){
  dat <- x$total
  names(dat) <- x$.id
  data.frame(doi=y, t(data.frame(dat, stringsAsFactors = FALSE)), stringsAsFactors = FALSE)
}
idsdata2 <- rbind_all(Map(almdat, idsdata$data, names(idsdata$data)))

# events data
events <- alm_events(res$doi)
# limit events to certain sources of data
sources <- c("counter", unique(res$alert_source))
eventsdata <- lapply(events, function(x) x[names(x) %in% sources])

foo <- function(x, y){
  tmp <- x$counter$events
  z <- if(NROW(tmp) == 0) data.frame(year=NA, month=NA, pdf_views=NA, html_views=NA, xml_views=NA) else tmp
  data.frame(doi=y, z, stringsAsFactors = FALSE)
}
events_counter <- Map(foo, events, names(events))
eventsdf <- tbl_df(rbind_all(events_counter))
alldf <- inner_join(x=eventsdf, y=res)
alldf <- inner_join(x=alldf, y=idsdata2)
alldf <- alldf %>% 
    mutate(date = as.Date(sprintf('%s-%s-01', year, month)))
alldf$alert_create_date <- as.Date(ymd_hms(alldf$alert_create_date))
alldf
```

```
## Source: local data frame [2,129 x 41]
## 
##                             doi year month pdf_views html_views xml_views
## 1  10.1371/journal.pone.0101787 2014     7        37        176        10
## 2  10.1371/journal.pone.0101787 2014     8        13         56         2
## 3  10.1371/journal.pone.0101787 2014     9        10         40         1
## 4  10.1371/journal.pone.0101787 2014    10         4         28         1
## 5  10.1371/journal.pone.0100491 2014     6        28        110        10
## 6  10.1371/journal.pone.0100491 2014     7        11         37         0
## 7  10.1371/journal.pone.0100491 2014     8         3         32         2
## 8  10.1371/journal.pone.0100491 2014     9         1         34         1
## 9  10.1371/journal.pone.0100491 2014    10         1         20         1
## 10 10.1371/journal.ppat.1004195 2014     6        59       1035        13
## ..                          ...  ...   ...       ...        ...       ...
## Variables not shown: alert_id (int), alert_val (dbl), alert_from (dbl),
##   alert_to (dbl), alert_create_date (date), alert_source (chr),
##   alert_class (chr), citeulike (int), crossref (int), nature (int), pubmed
##   (int), scopus (int), counter (int), researchblogging (int), wos (int),
##   pmc (int), facebook (int), mendeley (int), twitter (int), wikipedia
##   (int), scienceseeker (int), relativemetric (int), f1000 (int), figshare
##   (int), pmceurope (int), pmceuropedata (int), wordpress (int), reddit
##   (int), datacite (int), articlecoverage (int), articlecoveragecurated
##   (int), plos_comments (int), openedition (int), copernicus (int), date
##   (date)
```


> done updating above this line, on 2014-10-16


Plot data, top 10 DOIs


```r
alldf %>%
  select(-year, -month, -doi, -val, -source) %>%
  gather(metric, value, -article, -date, -create_date) %>%
#   arrange() %>%
  ggplot(aes(date, value, color=metric)) + 
    geom_line(size = 2, alpha = 0.7) + 
    geom_vline(aes(xintercept=as.numeric(create_date)), linetype="longdash") +
    facet_wrap(~ article, ncol = 2, scales = "free") +
    ggtitle("HtmlRatioTooHighError - Top ten highest HTML/PDF ratio articles\n")
```

Dig in to particular DOIs. This is rather free-form, depends on the metric of interest.


```r
doi1 <- '10.1371/journal.pbio.0040066'
alm_events(doi1, source = "facebook")
alm_ids(doi1, info = "detail")
```

Are the high value offender DOIs associated with other alm metrics, like social media metrics


```r
dat <- alm_ids(res$article[1:100], source = c("facebook","twitter"))
datdf <- rbind_all(dat$data)
datdf$article <- rep(res$article[1:100], each = 2)
datdf <- inner_join(datdf, res %>% filter(article %in% res$article[1:20]) %>% select(article, val) )

datdf %>% 
  ggplot(aes(x=val, y=total)) + 
    geom_point(aes(size=2)) +
    facet_wrap(~ .id, scales='free') +
    labs(y="", x="") +
    theme_grey(base_size = 18) +
    theme(legend.position="none")
```
