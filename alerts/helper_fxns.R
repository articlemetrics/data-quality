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
  tt <- data.frame(do.call(rbind, str_extract_all(x, "[0-9]+")))
  names(tt) <- c('high','low')
  tt
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


#     `Net::HTTPRequestTimeOut` = NA,
#     `Delayed::WorkerTimeout` = NA,
#     DelayedJobError = NA,
#     `Net::HTTPConflict` = NA,
#     `Net::HTTPUnauthorized` = NA,
#     `Net::HTTPRequestTimeOut` = NA,
#     `Delayed::WorkerTimeout` = NA,
#     `Net::HTTPServiceUnavailable` = NA,
#     `Faraday::ResourceNotFound` = NA,
#     `ActiveRecord::RecordInvalid` = NA,
#     TooManyErrorsBySourceError = NA,
#     `SourceInactiveError` = NA,
#     `TooManyWorkersError` = NA,
#     ApiResponseTooSlowError = NA,
#     CitationMilestoneAlert = NA
