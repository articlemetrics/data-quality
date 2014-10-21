library('stringr')
library('alm')

output.name <- "crossref/invalid_dois_2014-09-01.csv"
all_dat <- data.frame()

for (i in 1:18) {
  almdat <- alm_alerts(class_name = "ActiveRecord::RecordInvalid", 
                       url = "http://det.labs.crossref.org/api/v4/alerts", 
                       page = i, user="", pwd="")
  dat <- almdat$data
  dat$doi <- substr(dat$target_url,31,99)
  dat <- subset(dat, select=c("doi", "message","create_date"))
  all_dat <- rbind(all_dat, dat)
}           

# Then write it to a flat csv file
write.csv(all_dat, output.name,quote=FALSE,row.names=FALSE)
