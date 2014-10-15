-   Article Level Metrics Report on PLOS One articles
    -   Install packages
    -   Read in data
    -   Data cleaning/preparation
    -   Data summary
        -   Vizualize data
        -   Summary tables

Article Level Metrics Report on PLOS One articles
=================================================

The following is a summary of PLOS One articles from September 2013 to
September 2014. Data are from monthly files available via Martin
Fenner/Jennifer Lin. The main response variable used below is `counter`,
which is the combined PDF views (i.e., downloads) and HTML views on an
article. The first few steps below read in the data, then clean up the
data to get the subset we want. Then there are a few summary tables, and
a few vizualizations.

Prepared: 2014-10-14x

Install packages
----------------

If the below packages are not installed already, install them, then load
packages

    # install.packages(c('dplyr','stringr','ggplot2','knitr'))
    library('dplyr')
    library('stringr')
    library('ggplot2')
    library('GGally')
    library('knitr')
    options(stringsAsFactors = FALSE)

Read in data
------------

PLOS folks, Monthly reports are in a Google Drive folder, talk to Martin
if you want access, then change the path below to the location on your
machine. This workflow in the future will read files from Figshare so
that the data ingestion step is path independent.

    dir <- getwd()
    setwd("~/Google Drive/ALM Monthly Reports/")
    dat <- read.csv("alm_report_2014-09-10.csv", header = TRUE, sep = ",", stringsAsFactors=FALSE)
    dat2 <- tbl_df(dat)
    setwd(dir)

Data cleaning/preparation
-------------------------

remove annotation DOIs - NOTE: if you want these, don't run this next
few lines of code

    annot <- dat2 %>% filter(grepl('annotation', doi)) %>% select(doi)
    dat2 <- dat2 %>%
       filter(!doi %in% annot$doi)

Get only articles from `September 2013` to `August 2014`. Make
`publication_date` a date class first.

    dat2$publication_date <- as.Date(dat2$publication_date)
    dat2 <- dat2 %>%
      filter(publication_date > "2013-08-30", publication_date < "2014-09-01")

PLOS One articles only

    dat2 <- dat2 %>%
      filter(grepl("journal.pone", doi))

Take a quick look at the data, printing without the `title` field to
look at more columns. There are 33066 rows (i.e., articles) and 27
columns in the dataset.

    dat2 %>%
      select(-title)

    ## Source: local data frame [33,066 x 26]
    ##
    ##                             doi publication_date citeulike mendeley
    ## 1  10.1371/journal.pone.0000000       2014-08-18         4        6
    ## 2  10.1371/journal.pone.0070385       2013-10-21         0       12
    ## 3  10.1371/journal.pone.0068314       2013-09-02         0        3
    ## 4  10.1371/journal.pone.0068350       2013-09-02         0        3
    ## 5  10.1371/journal.pone.0070615       2013-09-02         0        8
    ## 6  10.1371/journal.pone.0070873       2013-09-02         0        5
    ## 7  10.1371/journal.pone.0070930       2013-09-02         0        2
    ## 8  10.1371/journal.pone.0071142       2013-09-02         0        6
    ## 9  10.1371/journal.pone.0071969       2013-09-02         0        3
    ## 10 10.1371/journal.pone.0071994       2013-09-02         0        1
    ## ..                          ...              ...       ...      ...
    ## Variables not shown: crossref (int), datacite (int), pmceurope (int),
    ##   pmceuropedata (int), pubmed (int), scopus (int), articlecoverage (int),
    ##   articlecoveragecurated (int), facebook (int), plos_comments (int),
    ##   nature (int), reddit (int), researchblogging (int), scienceseeker (int),
    ##   twitter (int), wikipedia (int), wordpress (int), counter (int), figshare
    ##   (int), pmc (int), relativemetric (int), f1000 (int)

Data summary
------------

All data is the `counter` variable

95% of the data are less than 5903 value of `counter`, so let's just
look at the top 99% of the data to get a better look at the data.

    df <- dat2 %>%
      filter(counter < quantile(dat2$counter, probs = c(0.99))[[1]])

### Vizualize data

The distribution of `counter` as a histogram

    df %>%
      ggplot(aes(x = counter)) +
        geom_histogram() +
        theme_grey(base_size = 20) +
        labs(y = "No. of articles", x = "Counter value")

![plot of chunk
histogram](./plos_report_2014-10-13_files/figure-markdown_strict/histogram.png)

The value of `counter` for each article decreases through time

    df %>%
      ggplot(aes(x = publication_date, y = counter)) +
        geom_point() +
        geom_smooth() +
        theme_grey(base_size = 20) +
        labs(y = "Counter value", x = "Publication date")

![plot of chunk
throughtime](./plos_report_2014-10-13_files/figure-markdown_strict/throughtime.png)

The value of `counter` against X

    df %>%
      select(counter, mendeley, crossref, facebook, reddit, twitter, wikipedia) %>%
      ggpairs(upper = "blank")

![plot of chunk
pairs](./plos_report_2014-10-13_files/figure-markdown_strict/pairs.png)

### Summary tables

Summary by month

    add_yrmonth <- function(x) paste(strsplit(as.character(x), "-")[[1]][1:2], collapse = "-")
    df$yr_month <- sapply(df$publication_date, add_yrmonth)

    df3 <- df %>%
      group_by(yr_month) %>%
      summarise(sum = sum(counter, na.rm = TRUE),
                min = min(counter, na.rm = TRUE),
                max = max(counter, na.rm = TRUE),
                mean = round(mean(counter, na.rm = TRUE), 1),
                sd = round(sd(counter, na.rm = TRUE), 1),
                se = round(sd(counter, na.rm = TRUE) / sqrt(length(counter)), 1),
                no_articles = length(counter))

    kable(df3, "markdown")

<table>
<thead>
<tr class="header">
<th align="left">yr_month</th>
<th align="right">sum</th>
<th align="right">min</th>
<th align="right">max</th>
<th align="right">mean</th>
<th align="right">sd</th>
<th align="right">se</th>
<th align="right">no_articles</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">2013-09</td>
<td align="right">3577010</td>
<td align="right">319</td>
<td align="right">5880</td>
<td align="right">1325.3</td>
<td align="right">743.0</td>
<td align="right">14.3</td>
<td align="right">2699</td>
</tr>
<tr class="even">
<td align="left">2013-10</td>
<td align="right">3419635</td>
<td align="right">299</td>
<td align="right">5874</td>
<td align="right">1287.5</td>
<td align="right">765.9</td>
<td align="right">14.9</td>
<td align="right">2656</td>
</tr>
<tr class="odd">
<td align="left">2013-11</td>
<td align="right">3175002</td>
<td align="right">242</td>
<td align="right">5900</td>
<td align="right">1104.7</td>
<td align="right">699.6</td>
<td align="right">13.1</td>
<td align="right">2874</td>
</tr>
<tr class="even">
<td align="left">2013-12</td>
<td align="right">2867977</td>
<td align="right">227</td>
<td align="right">5788</td>
<td align="right">954.1</td>
<td align="right">603.5</td>
<td align="right">11.0</td>
<td align="right">3006</td>
</tr>
<tr class="odd">
<td align="left">2014-01</td>
<td align="right">3294873</td>
<td align="right">220</td>
<td align="right">5811</td>
<td align="right">1109.0</td>
<td align="right">674.4</td>
<td align="right">12.4</td>
<td align="right">2971</td>
</tr>
<tr class="even">
<td align="left">2014-02</td>
<td align="right">2715368</td>
<td align="right">109</td>
<td align="right">5863</td>
<td align="right">1034.0</td>
<td align="right">671.8</td>
<td align="right">13.1</td>
<td align="right">2626</td>
</tr>
<tr class="odd">
<td align="left">2014-03</td>
<td align="right">2572052</td>
<td align="right">74</td>
<td align="right">5838</td>
<td align="right">867.5</td>
<td align="right">581.2</td>
<td align="right">10.7</td>
<td align="right">2965</td>
</tr>
<tr class="even">
<td align="left">2014-04</td>
<td align="right">2107732</td>
<td align="right">97</td>
<td align="right">5842</td>
<td align="right">754.9</td>
<td align="right">545.3</td>
<td align="right">10.3</td>
<td align="right">2792</td>
</tr>
<tr class="odd">
<td align="left">2014-05</td>
<td align="right">1530088</td>
<td align="right">91</td>
<td align="right">5642</td>
<td align="right">644.2</td>
<td align="right">497.9</td>
<td align="right">10.2</td>
<td align="right">2375</td>
</tr>
<tr class="even">
<td align="left">2014-06</td>
<td align="right">1370390</td>
<td align="right">79</td>
<td align="right">5785</td>
<td align="right">512.9</td>
<td align="right">393.9</td>
<td align="right">7.6</td>
<td align="right">2672</td>
</tr>
<tr class="odd">
<td align="left">2014-07</td>
<td align="right">1086467</td>
<td align="right">43</td>
<td align="right">5114</td>
<td align="right">432.7</td>
<td align="right">431.2</td>
<td align="right">8.6</td>
<td align="right">2511</td>
</tr>
<tr class="even">
<td align="left">2014-08</td>
<td align="right">940933</td>
<td align="right">32</td>
<td align="right">5646</td>
<td align="right">363.6</td>
<td align="right">368.9</td>
<td align="right">7.3</td>
<td align="right">2588</td>
</tr>
</tbody>
</table>
