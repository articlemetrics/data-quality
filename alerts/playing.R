library(rCharts)
h1 <- Highcharts$new()
h1$chart(type = "spline")
h1$series(data = c(1, 3, 2, 4, 5, 4, 6, 2, 3, 5, NA), dashStyle = "longdash")
h1$series(data = c(NA, 4, 1, 3, 4, 2, 9, 1, 2, 3, 4), dashStyle = "shortdot")
h1$legend(symbolWidth = 80)
h1

data(economics, package = 'ggplot2')
econ <- transform(economics, date = as.character(date))
m1 <- mPlot(x = 'date', y = c('psavert', 'uempmed'), type = 'Line', data = econ)
m1$set(pointSize = 0, lineWidth = 1)
m1


stuff <- alldf_alldois %>%
  select(article, date, ratio) %>%
  filter(!article %in% c('10.1371/journal.pbio.0000008','10.1371/journal.pbio.0020146')) %>%
  spread(article, ratio)
m1 <- mPlot(x = 'date', y = names(stuff)[2:20], type = 'Line', data = stuff)
m1$set(pointSize = 0, lineWidth = 1)
m1

library('ggvis')

alldf_alldois %>%
  select(article, date, ratio) %>%
  filter(!article %in% c('10.1371/journal.pbio.0000008','10.1371/journal.pbio.0020146',"10.1371/journal.pone.0010894")) %>%
  ggvis(~date, ~ratio) %>% 
  group_by(article) %>% 
  add_tooltip(function(x) x$article)
#   handle_click(function(data, ...) str(data))
#   layer_lines() %>%
