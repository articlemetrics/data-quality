#' Function to parse alerts messages differenlty depending on the alert class
#'
#' @param x Input data.frame from a call to \code{alm_alerts()}
#' @param class Class of alert. See \code{alert_classes()} for alert classes
#' @examples \donttest{
#' rs <- alm_alerts()
#' head( alerts_parse(rs) )
#' 
#' rs <- alm_alerts(class_name = "HtmlRatioTooHighError")
#'
#' # Parse messages from alerts into new columns
#' # doesn't matter if you have one class or many in the dataset
#' head( alerts_parse(x = rs$data) )
#' 
#' rs <- alm_alerts(class_name = 'DelayedJobError')
#' head( alerts_parse(x = rs$data) )
#' }

alerts_parse <- function(x){
  df <- tbl_df(x)
  out <- df %>% 
    rowwise() %>% 
    do(parser(class=.$class_name, mssg=.$message))
  data.frame(x, out, stringsAsFactors = FALSE)
}

foo <- function(x){
  tt <- as.numeric(str_extract_all(x, "[0-9]+")[[1]])
  data.frame(from=tt[1], to=tt[2], val=tt[1] - tt[2], stringsAsFactors = FALSE)
}

bar <- function(y) data.frame(val=as.numeric(vapply(y, str_extract, character(1), pattern="[0-9]+", USE.NAMES = FALSE)), stringsAsFactors = FALSE)

parser <- function(class, mssg){
  if(class %in% c('HtmlRatioTooHighError','EventCountDecreasingError','EventCountIncreasingTooFastError','ArticleNotUpdatedError')){
    switch(class,
           HtmlRatioTooHighError = data.frame(val=as.numeric(str_extract(mssg, "[0-9]+\\.?[0-9]+"))),
           EventCountDecreasingError = foo(mssg),
           EventCountIncreasingTooFastError = bar(mssg),
           ArticleNotUpdatedError = bar(mssg)
    )
  } else { data.frame(val=NA, stringsAsFactors = FALSE) }
}

alerts_by_class <- function(class_name=NULL, limit=NULL){
  assert_that(!is.null(class_name))
  num_res <- alm_alerts(class_name = class_name)$meta$total
  if(!is.null(limit)) num_res <- min(c(num_res, limit))
  if(!num_res == 0){
    pgs <- 1:(round_any(num_res, 50, ceiling)/50)
    xx <- rbind.fill(lapply(pgs, function(x) alm_alerts(page=x, class_name = class_name)$data))
    xx <- alerts_parse(xx)
    xx <- xx[ !duplicated(xx[,!names(xx) %in% c('id','create_date',"unresolved")]) , ]
    tmp <- 
      if(class_name=="EventCountDecreasingError"){
        tbl_df(xx) %>% select(id, article, val, from, to, create_date, source) 
      } else { tbl_df(xx) %>% select(id, article, val, create_date, source) }
    tmp %>%
      arrange(desc(val)) %>%
      mutate(class = class_name)
  } else { tbl_df(data.frame(NULL)) }
}

clean_events <- function(x){
  tmp <- lapply(x, function(y){
    if(is.character(y)){
      if(y == "sorry, no events content yet") NULL else y 
    } else { y }
  })
  compact(tmp)
}

add_events_data <- function(dat, x){
  events <- alm_events(x, source = "counter")
  foo <- function(x, y){
    tmp <- x$counter$events
    data.frame(article=y, tmp, stringsAsFactors = FALSE)
  }
  events <- Map(foo, events, names(events))
  eventsdf <- tbl_df(rbind_all(events))
  tmpdf <- inner_join(x=eventsdf, y=dat)
  tmpdf <- tmpdf %>% 
    mutate(date = as.Date(sprintf('%s-%s-01', year, month)), ratio = htmlpdfr(html_views, pdf_views))
  tmpdf$create_date <- as.Date(ymd_hms(tmpdf$create_date))
  tmpdf
}

htmlpdfr <- function(x, y){
  x <- ifelse(x == 0, 1, x)
  y <- ifelse(y == 0, 1, y)
  x/y
}

rbind_all_named <- function(dat){
  tmp <- Map(function(x, y){ x$doi <- y; x }, dat, names(dat))
  rbind_all(tmp)
}
