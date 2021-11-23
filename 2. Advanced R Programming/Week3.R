#Debugging
##traceback
check_n_value <- function(n) {
  if(n > 0) {
    stop("n should be <= 0")
  }
}
error_if_n_is_greater_than_zero <- function(n){
  check_n_value(n)
  n
}
error_if_n_is_greater_than_zero(5)

##browsing a function environment
check_n_value <- function(n) {
  if(n > 0) {
    browser()  ## Error occurs around here
    stop("n should be <= 0")
  }
}
error_if_n_is_greater_than_zero(5)

##tracing functions
trace("check_n_value")
error_if_n_is_greater_than_zero(5)

as.list(body(check_n_value))

as.list(body(check_n_value)[[2]])

trace("check_n_value", browser, at = list(c(2, 3)))

check_n_value

body(check_n_value)

trace("check_n_value", quote({
  if(n == 5) {
    message("invoking the browser")
    browser()
  }
}), at = 2)

body(check_n_value)

##debugging within package
trace("glm", browser, at = 4, where = asNamespace("stats"))
body(stats::glm)[1:5]

##using debug() and debugonce()
debug(lm) ##debug() is persistent while debugonce() will turn on only one time

##recover
options(error = recover)
error_if_n_is_greater_than_zero(5)

#profiling
##microbenchmark
library(microbenchmark)
microbenchmark(a <- rnorm(1000),
               b <- mean(rnorm(1000)))

# Function that uses a loop 
find_records_1 <- function(datafr, threshold){
  highest_temp <- c()
  record_temp <- c()
  for(i in 1:nrow(datafr)){
    highest_temp <- max(highest_temp, datafr$temp[i])
    record_temp[i] <- datafr$temp[i] >= threshold & 
      datafr$temp[i] >= highest_temp
  }
  datafr <- cbind(datafr, record_temp)
  return(datafr)
}

# Function that uses tidyverse functions
find_records_2 <- function(datafr, threshold){
  datafr <- datafr %>%
    mutate_(over_threshold = ~ temp >= threshold,
            cummax_temp = ~ temp == cummax(temp),
            record_temp = ~ over_threshold & cummax_temp) %>%
    select_(.dots = c("-over_threshold", "-cummax_temp"))
  return(as.data.frame(datafr))
}


example_data <- data_frame(date = c("2015-07-01", "2015-07-02",
                                    "2015-07-03", "2015-07-04",
                                    "2015-07-05", "2015-07-06",
                                    "2015-07-07", "2015-07-08"),
                           temp = c(26.5, 27.2, 28.0, 26.9, 
                                    27.5, 25.9, 28.0, 28.2))

(test_1 <- find_records_1(example_data, 27))

(test_2 <- find_records_2(example_data, 27))

all.equal(test_1, test_2)

record_temp_perf <- microbenchmark(find_records_1(example_data, 27), 
                                   find_records_2(example_data, 27))
record_temp_perf

library(dlnm)
data("chicagoNMMAPS")

record_temp_perf_2 <- microbenchmark(find_records_1(chicagoNMMAPS, 27), 
                                     find_records_2(chicagoNMMAPS, 27))
record_temp_perf_2

library(ggplot2)

autoplot(record_temp_perf)
autoplot(record_temp_perf_2)

#profvis
library(profvis)
datafr <- chicagoNMMAPS
threshold <- 27

profvis({
  highest_temp <- c()
  record_temp <- c()
  for(i in 1:nrow(datafr)){
    highest_temp <- max(highest_temp, datafr$temp[i])
    record_temp[i] <- datafr$temp[i] >= threshold & 
      datafr$temp[i] >= highest_temp
  }
  datafr <- cbind(datafr, record_temp)
})

# non-standard evaluation
