data-quality code
========================================================



## Install packages 

If the below packages are not installed already, then load package


```r
options(stringsAsFactors = FALSE)
# install.packages(c('dplyr','stringr','tidyr'))
# devtools::install_github("ropensci/alm", ref="alerts")
library('dplyr')
library('stringr')
library('alm')
library('ggplot2')
library('tidyr')
```

## Read in data

PLOS folks, Monthly reports are in a Google Drive folder, talk to Martin if you want access


```r
dir <- getwd()
setwd("~/Google Drive/ALM Monthly Reports/PLOS")
files <- list.files(".", pattern = ".csv")
read_file <- function(x){
  tmp <- read.csv(x, header = TRUE, sep = ",", stringsAsFactors=FALSE)
  tmp$datafrom <- as.Date(str_extract(x, "[0-9]{4}-[0-9]{2}-[0-9]{2}"), "%Y-%m-%d")
  tmp
  }
dat <- lapply(files, read_file)
alldat <- rbind_all(dat)
(dat2 <- tbl_df(alldat))
```

```
## Source: local data frame [1,403,224 x 48]
## 
##                             doi  published
## 1  10.1371/journal.pbio.0000001 2003-10-13
## 2  10.1371/journal.pbio.0000002 2003-11-17
## 3  10.1371/journal.pbio.0000003 2003-11-17
## 4  10.1371/journal.pbio.0000004 2003-10-13
## 5  10.1371/journal.pbio.0000005 2003-08-18
## 6  10.1371/journal.pbio.0000006 2003-08-18
## 7  10.1371/journal.pbio.0000007 2003-08-18
## 8  10.1371/journal.pbio.0000008 2003-10-13
## 9  10.1371/journal.pbio.0000009 2003-10-13
## 10 10.1371/journal.pbio.0000010 2003-10-13
## ..                          ...        ...
## Variables not shown: title (chr), bloglines (int), citeulike (int),
##   connotea (int), crossref (int), nature (int), postgenomic (int), pubmed
##   (int), researchblogging (int), scopus (int), twitter (int), counter_html
##   (int), counter_pdf (int), counter_xml (int), pmc_html (int), pmc_pdf
##   (int), facebook (int), mendeley_readers (int), mendeley_groups (int),
##   comments (int), comment_replies (int), notes (int), note_replies (int),
##   ratings (int), avg_rating (dbl), rating_comments (int), trackbacks
##   (int), datafrom (date), biod (int), counter (int), pmc (int), mendeley
##   (int), publication_date (chr), wikipedia (int), scienceseeker (int),
##   f1000 (int), figshare (int), pmceurope (int), pmceuropedata (int),
##   wordpress (int), reddit (int), datacite (int), articlecoveragecurated
##   (int), articlecoverage (int), plos_comments (int), relativemetric (int)
```

```r
setwd(dir)
```

## Data cleaning


```r
# new column with date for each row, drop other pub date columns
# and move title to end for easier viewing
(dat2 <- dat2 %>%
   mutate(pubdate = published[1], title2 = title) %>%
   select(-published, -publication_date, -title))
```

```
## Source: local data frame [1,403,224 x 47]
## 
##                             doi bloglines citeulike connotea crossref
## 1  10.1371/journal.pbio.0000001         0         0        0        9
## 2  10.1371/journal.pbio.0000002         0         4        0       83
## 3  10.1371/journal.pbio.0000003         0         0        0        0
## 4  10.1371/journal.pbio.0000004         0         0        0        0
## 5  10.1371/journal.pbio.0000005         0        10        6      316
## 6  10.1371/journal.pbio.0000006         0         0        0       15
## 7  10.1371/journal.pbio.0000007         0         2        0        0
## 8  10.1371/journal.pbio.0000008         0         0        0        6
## 9  10.1371/journal.pbio.0000009         0         1        0        1
## 10 10.1371/journal.pbio.0000010         0        14        2      116
## ..                          ...       ...       ...      ...      ...
## Variables not shown: nature (int), postgenomic (int), pubmed (int),
##   researchblogging (int), scopus (int), twitter (int), counter_html (int),
##   counter_pdf (int), counter_xml (int), pmc_html (int), pmc_pdf (int),
##   facebook (int), mendeley_readers (int), mendeley_groups (int), comments
##   (int), comment_replies (int), notes (int), note_replies (int), ratings
##   (int), avg_rating (dbl), rating_comments (int), trackbacks (int),
##   datafrom (date), biod (int), counter (int), pmc (int), mendeley (int),
##   wikipedia (int), scienceseeker (int), f1000 (int), figshare (int),
##   pmceurope (int), pmceuropedata (int), wordpress (int), reddit (int),
##   datacite (int), articlecoveragecurated (int), articlecoverage (int),
##   plos_comments (int), relativemetric (int), pubdate (chr), title2 (chr)
```

```r
# remove negative numbers in facebook
(dat2 <- dat2 %>%
   filter(facebook >= 0))
```

```
## Source: local data frame [1,403,120 x 47]
## 
##                             doi bloglines citeulike connotea crossref
## 1  10.1371/journal.pbio.0000001         0         0        0        9
## 2  10.1371/journal.pbio.0000002         0         4        0       83
## 3  10.1371/journal.pbio.0000003         0         0        0        0
## 4  10.1371/journal.pbio.0000004         0         0        0        0
## 5  10.1371/journal.pbio.0000005         0        10        6      316
## 6  10.1371/journal.pbio.0000006         0         0        0       15
## 7  10.1371/journal.pbio.0000007         0         2        0        0
## 8  10.1371/journal.pbio.0000008         0         0        0        6
## 9  10.1371/journal.pbio.0000009         0         1        0        1
## 10 10.1371/journal.pbio.0000010         0        14        2      116
## ..                          ...       ...       ...      ...      ...
## Variables not shown: nature (int), postgenomic (int), pubmed (int),
##   researchblogging (int), scopus (int), twitter (int), counter_html (int),
##   counter_pdf (int), counter_xml (int), pmc_html (int), pmc_pdf (int),
##   facebook (int), mendeley_readers (int), mendeley_groups (int), comments
##   (int), comment_replies (int), notes (int), note_replies (int), ratings
##   (int), avg_rating (dbl), rating_comments (int), trackbacks (int),
##   datafrom (date), biod (int), counter (int), pmc (int), mendeley (int),
##   wikipedia (int), scienceseeker (int), f1000 (int), figshare (int),
##   pmceurope (int), pmceuropedata (int), wordpress (int), reddit (int),
##   datacite (int), articlecoveragecurated (int), articlecoverage (int),
##   plos_comments (int), relativemetric (int), pubdate (chr), title2 (chr)
```

```r
# remove annotation DOIs - NOTE: if you want these, don't run this next few lines of code
annot <- dat2 %>% filter(grepl('annotation', doi)) %>% select(doi)
(dat2 <- dat2 %>% 
   filter(!doi %in% annot$doi))
```

```
## Source: local data frame [1,384,915 x 47]
## 
##                             doi bloglines citeulike connotea crossref
## 1  10.1371/journal.pbio.0000001         0         0        0        9
## 2  10.1371/journal.pbio.0000002         0         4        0       83
## 3  10.1371/journal.pbio.0000003         0         0        0        0
## 4  10.1371/journal.pbio.0000004         0         0        0        0
## 5  10.1371/journal.pbio.0000005         0        10        6      316
## 6  10.1371/journal.pbio.0000006         0         0        0       15
## 7  10.1371/journal.pbio.0000007         0         2        0        0
## 8  10.1371/journal.pbio.0000008         0         0        0        6
## 9  10.1371/journal.pbio.0000009         0         1        0        1
## 10 10.1371/journal.pbio.0000010         0        14        2      116
## ..                          ...       ...       ...      ...      ...
## Variables not shown: nature (int), postgenomic (int), pubmed (int),
##   researchblogging (int), scopus (int), twitter (int), counter_html (int),
##   counter_pdf (int), counter_xml (int), pmc_html (int), pmc_pdf (int),
##   facebook (int), mendeley_readers (int), mendeley_groups (int), comments
##   (int), comment_replies (int), notes (int), note_replies (int), ratings
##   (int), avg_rating (dbl), rating_comments (int), trackbacks (int),
##   datafrom (date), biod (int), counter (int), pmc (int), mendeley (int),
##   wikipedia (int), scienceseeker (int), f1000 (int), figshare (int),
##   pmceurope (int), pmceuropedata (int), wordpress (int), reddit (int),
##   datacite (int), articlecoveragecurated (int), articlecoverage (int),
##   plos_comments (int), relativemetric (int), pubdate (chr), title2 (chr)
```

## Through time

Compare each metric separately through time for the same DOIs

### Citeulike data


```r
# get dois that have a change in their value of at least n = 10 (modify)  
citeu_dois <- dat2 %>% 
  select(doi, datafrom, citeulike) %>% 
  group_by(doi) %>% 
  summarise(
    diff = max(citeulike) - min(citeulike)
    ) %>% 
  filter(diff > 10) %>% 
  select(doi)

# Visualize data
dat2 %>% 
  select(doi, datafrom, citeulike) %>% 
  filter(doi %in% citeu_dois$doi) %>% 
  ggplot(aes(datafrom, citeulike, group=doi)) + geom_line()
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

### Mendeley data


```r
# get dois that have a change in their value of at least n = 10 (modify)
mendeley_dois <-  dat2 %>% 
  select(doi, datafrom, mendeley) %>%
  group_by(doi) %>% 
  summarise(
    diff = max(mendeley, na.rm = TRUE) - min(mendeley, na.rm = TRUE)
    ) %>% 
  filter(diff > 90) %>%
  select(doi)

# Visualize data
# dat2 %>%
#   select(doi, datafrom, mendeley) %>%
#   filter(doi %in% mendeley_dois$doi) %>% 
#   ggplot(aes(datafrom, mendeley, group=doi)) + geom_line()

# Visualize data - without outliers
outliers <- unique(dat2 %>% filter(mendeley > 5000) %>% select(doi))$doi
dat2 %>%
  select(doi, datafrom, mendeley) %>%
  filter(doi %in% mendeley_dois$doi, !doi %in% outliers) %>% 
  ggplot(aes(datafrom, mendeley, group=doi)) + geom_line()
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 

## Across metrics

### Counter: html vs. pdf views

Compare different metrics across the same DOIs in one time slice

First, remove last three dates as they don't have counter_pdf or counter_html data


```r
norecent_counter <- dat2 %>% 
  select(doi, datafrom, contains('counter')) %>% 
  filter(!as.character(datafrom) %in% c('2014-06-10','2014-07-10',"2014-08-10","2014-09-10"))
```


```r
norecent_counter %>% 
  ggplot(aes(log10(counter_html+1), log10(counter_pdf+1))) + geom_point() + facet_wrap(~ datafrom)
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

Do slopes through time differ?


```r
# remove last three dates as they don't have counter_pdf or counter_html data
# calculate slopes, define function to get slope and confidence interval first
get_coef <- function(x){
  tmp <- lm(counter_pdf ~ counter_html, data = x)
  df <- data.frame(datafrom=x$datafrom[1], slope=coefficients(tmp)[['counter_html']], t(confint(tmp)[2,]))
  names(df)[3:4] <- c('low','high')
  df
}

res <- norecent_counter %>% 
  group_by(datafrom) %>%
  do(out = get_coef(.))
df <- res$out %>% rbind_all

df %>%
  ggplot(aes(datafrom, slope)) + 
  geom_point(aes(size=4)) + 
  theme_grey(20) + 
  theme(legend.position="none") + 
  labs(y="Slope of html to pdf views\n")
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9.png) 
