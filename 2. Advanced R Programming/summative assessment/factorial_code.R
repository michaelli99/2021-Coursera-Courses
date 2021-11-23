#Factorial function
library(tidyverse)
library(microbenchmark)

# 1.Factorial_loop: a version that computes the factorial of an integer using 
# looping (such as a for loop)
Factorial_loop <- function(n){
  factorial <- 1
  if(n == 0){
    return(factorial)
  }
  if(n > 0 && n%%1 == 0){
    for(i in 1:n){
      factorial <- factorial*i
    }
    return(factorial)
  }
  else{
    message("Not a natural number.
Please enter a natural number.")
  }
}

# 2.Factorial_reduce: a version that computes the factorial using the reduce() 
# function in the purrr package. Alternatively, you can use the Reduce() 
# function in the base package.
Factorial_reduce <- function(n){
  if(n == 0){
    return(1)
  }
  if(n > 0 && n%%1 == 0){
    reduce(as.numeric(1:n), `*`)
# I used as.numeric here because otherwise the reduce function cannot generate
# the result when n is greater than 13.
  }
  else{
    message("Not a natural number.
Please enter a natural number.")
  }
}


# 3.Factorial_func: a version that uses recursion to compute the factorial.
Factorial_func <- function(n){
  if(n == 0){
    return(1)
  }
  if(n > 0 && n%%1 == 0){
    return(n*Factorial_func(n-1))
  }
  else{
    message("Not a natural number.
Please enter a natural number.")
  }
}

# 4.Factorial_mem: a version that uses memoization to compute the factorial.
Factorial_tbl <- c(1, rep(NA,10))
Factorial_mem <- function(n){
  if(n == 0){
    return(1)
  }
  if(n > 0 && n%%1 == 0){
    if(!is.na(Factorial_tbl[n])){
      return(Factorial_tbl[n])
    }
    else{
      Factorial_tbl[n-1] <<- Factorial_mem(n-1)
      return(n*Factorial_tbl[n-1])
    }
  }
  else{
    message("Not a natural number.
Please enter a natural number.")
  }
}

# Benchmark tests for functions
Functions_bench_compare <- function(test_num, time_num = 100){
  Factorial_tbl <- c(1, rep(NA,test_num))
  microbenchmark(
    Function_1 <- Factorial_loop(test_num),
    Function_2 <- Factorial_reduce(test_num),
    Function_3 <- Factorial_func(test_num),
    Function_4 <- Factorial_mem(test_num),
    times = time_num
  )
}

# Compare the test results for 1
test_for_1 <- Functions_bench_compare(1)
test_for_1
autoplot(test_for_1)

# Compare the test results for 10
test_for_10 <- Functions_bench_compare(10)
test_for_10
autoplot(test_for_10)

# Compare the test results for 100
test_for_100 <- Functions_bench_compare(100)
test_for_100
autoplot(test_for_100)

# Compare the test results for 1000
test_for_1000 <- Functions_bench_compare(1000)
test_for_1000
autoplot(test_for_1000)

