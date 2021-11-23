library(tidyverse)
#Functional Programming
adder_maker <- function(n){
  function(x){
    n + x
  }
}

add2 <- adder_maker(2)
add3 <- adder_maker(3)

add2(5)
add3(5)

##map
library(purrr)

##apply the vector to the function of characters
map_chr(c(4, 3, 2, 1), function(x){
  c("one", "two", "three", "four", "five")[x]
})

##apply the vector to the function of logic
map_lgl(c(1, 2, 3, 4, 5), function(x){
  x > 3
})

##apply the vector to the function of x first. If true, apply the element to 
##function y, and then to 
map_if(1:5, function(x){
  x %% 2 == 0
},
function(y){
  y^2
}) %>% unlist()


##The map_at() function only applies the provided function to elements of a vector
##specified by their indexes
map_at(seq(100, 500, 100), c(1, 3, 5), function(x){
  x - 10
}) %>% unlist()

##can map a function over two data structures with the map2() family of functions.
map2_chr(letters, 1:26, paste)
map2_chr(letters, 1:26, paste)

##The pmap() family of functions is similar to map2(), 
##however instead of mapping across two vectors or lists,
##you can map across any number of lists.
pmap_chr(list(
  list(1, 2, 3),
  list("one", "two", "three"),
  list("uno", "dos", "tres")
), paste0)

##Reduce: List or vector reduction iteratively 
##combines the first element of a vector with the second element of a vector, 
##then that combined result is combined with the third element of the vector, 
##and so on until the end of the vector is reached.
reduce(c(1, 3, 5, 7), function(x, y){
  message("x is ", x)
  message("y is ", y)
  message("")
  x + y #a reduce will return a single value in the end
})

reduce(letters[1:4], function(x, y){
  message("x is ", x)
  message("y is ", y)
  message("")
  paste0(x, y)
})

reduce_right(letters[1:4], function(x, y){
  message("x is ", x)
  message("y is ", y)
  message("")
  paste0(x, y)
})

##new expression, see below:
reduce(rev(letters[1:4]), function(x, y){
  message("x is ", x)
  message("y is ", y)
  message("")
  paste0(x, y)
})

##search
has_element(letters, "a")

has_element(letters, "A")


detect(20:40, function(x){
  x > 22 && x %% 2 == 0
})

detect_index(20:40, function(x){
  x > 22 && x %% 2 == 0
})

##filter
keep(1:20, function(x){
  x %% 2 == 0
})

discard(1:20, function(x){
  x %% 2 == 0
})

every(1:20, function(x){
  x %% 2 == 0
})

every(keep(1:20, function(x){
  x %% 2 == 0
}), function(x){
  x %% 2 == 0
})

some(1:20, function(x){
  x %% 2 == 0
})

##compose
n_unique <- compose(length, unique)
rep(1:5, 1:5)
n_unique(rep(1:5, 1:5))

##partial application
mult_three_n <- function(x, y, z){
  x * y * z
}
mult_by_15 <- partial(mult_three_n, x = 3, y = 5)
mult_by_15(z = 4)

##side effects
walk(c("Friends, Romans, countrymen,",
       "lend me your ears;",
       "I come to bury Caesar,",
       "not to praise him."), message)
walk(c("Friends, Romans, countrymen,",
       "lend me your ears;",
       "I come to bury Caesar,",
       "not to praise him."), print)
walk(c("Friends, Romans, countrymen,",
       "lend me your ears;",
       "I come to bury Caesar,",
       "not to praise him."), cat)

##Recursion
vector_sum_loop <- function(v){
  result <- 0
  for(i in v){
    result <- result + i
  }
  result
}
vector_sum_loop(c(5, 40, 91))

vector_sum_rec <- function(v){
  if(length(v) == 1){
    v
  } else {
    v[1] + vector_sum_rec(v[-1])
  }
}

vector_sum_rec(c(5, 40, 91))

###Fibonacci number
fib <- function(n){
  stopifnot(n > 0)
  if(n == 1){
    0
  } else if(n == 2){
    1
  } else {
    fib(n - 1) + fib(n - 2)
  }
}

map_dbl(1:10, fib)

fib_tbl <- c(0, 1, rep(NA, 23))

fib_mem <- function(n){
  stopifnot(n > 0)
  if(!is.na(fib_tbl[n])){
    fib_tbl[n]
  } else {
    fib_tbl[n - 1] <<- fib_mem(n - 1)
    fib_tbl[n - 2] <<- fib_mem(n - 2)
    fib_tbl[n - 1] + fib_tbl[n - 2]
  }
}

map_dbl(1:12, fib_mem)

library(purrr)
library(microbenchmark)
library(tidyr)
library(magrittr)
library(dplyr)

fib_data <- map(1:10, function(x){microbenchmark(fib(x), times = 100)$time})
names(fib_data) <- paste0(letters[1:10], 1:10)
fib_data <- as.data.frame(fib_data)
fib_data %<>%
  gather(num, time) %>%
  group_by(num) %>%
  summarise(med_time = median(time))
memo_data <- map(1:10, function(x){microbenchmark(fib_mem(x))$time})
names(memo_data) <- paste0(letters[1:10], 1:10)
memo_data <- as.data.frame(memo_data)
memo_data %<>%
  gather(num, time) %>%
  group_by(num) %>%
  summarise(med_time = median(time))
plot(1:10, fib_data$med_time, xlab = "Fibonacci Number", ylab = "Median Time (Nanoseconds)",
     pch = 18, bty = "n", xaxt = "n", yaxt = "n")
axis(1, at = 1:10)
axis(2, at = seq(0, 350000, by = 50000))
points(1:10 + .1, memo_data$med_time, col = "blue", pch = 18)
legend(1, 300000, c("Not Memoized", "Memoized"), pch = 18,
       col = c("black", "blue"), bty = "n", cex = 1, y.intersp = 1.5)

#expressions & environments
##expressions
two_plus_two <- quote(2 + 2)
two_plus_two
eval(two_plus_two)
tpt_string <- "2 + 2"
tpt_expression <- parse(text = tpt_string)
eval(tpt_expression)

sum_expr <- quote(sum(1, 5))
eval(sum_expr)
sum_expr[1]
sum_expr[2]
sum_expr[3]
sum_expr[[1]]
sum_expr[[2]]
sum_expr[[3]]
sum_expr[[1]] <- quote(paste0)
sum_expr[[2]] <- quote(4)
sum_expr[[3]] <- quote(6)
eval(sum_expr)

sum_40_50_expr <- call("sum", 40, 50)
sum_40_50_expr
sum(40, 50)
eval(sum_40_50_expr)

return_expression <- function(...){
  match.call()
}
return_expression(2, col = "blue", FALSE)
return_expression(2, col = "blue", FALSE)

first_arg <- function(...){
  expr <- match.call()
  first_arg_expr <- expr[[2]]
  first_arg <- eval(first_arg_expr)
  if(is.numeric(first_arg)){
    paste("The first argument is", first_arg)
  } else {
    "The first argument is not numeric."
  }
}
first_arg(2, 4, "seven", FALSE)
first_arg("two", 4, "seven", FALSE)

##environments
my_new_env <- new.env()
my_new_env$x <- 4
my_new_env$x

assign("y", 9, envir = my_new_env)
get("y", envir = my_new_env)

my_new_env$y

ls(my_new_env)
rm(y, envir = my_new_env)
exists("y", envir = my_new_env)
exists("x", envir = my_new_env)
my_new_env$x
my_new_env$y

search()
library(ggplot2)
search()

##execution environments
x <- 10
my_func <- function(){
  x <- 5
  return(x)
}
my_func()

x <- 10
another_func <- function(){
  return(x)
}
another_func()

x <- 10
x
assign1 <- function(){
  x <<- "Wow!"
}
assign1()
x

a_variable_name
exists("a_variable_name")

assign2 <- function(){
  a_variable_name <<- "Magic!"
}
assign2()
exists("a_variable_name")
a_variable_name

#Error handling and generation
##Error
"hello" + "world"

## Warnings
as.numeric(c("5", "6", "seven"))

##message
f <- function(){
  message("This is a message.")
}
f()

##generating errors
stop("Something erroneous has occured!")

name_of_function <- function(){
  stop("Something bad happened.")
}

name_of_function()

error_if_n_is_greater_than_zero <- function(n){
  stopifnot(n<= 0)
  n
}

error_if_n_is_greater_than_zero(5)

warning("Consider yourself warned!")

make_NA <- function(x){
  warning("Generating an NA.")
  NA
}

make_NA("Sodium")
message("In a bottle.")

##how to handle error
beera <- function(expr){
  tryCatch(expr,
           error = function(a){
             message("An error occurred:\n", a)
           },
           warning = function(w){
             message("A warning occured:\n", w)
           },
           finally = {
             message("Finally done!")
           })
}

beera({
  2 + 2
})

beera({
  "two" + 2
})

beera({
  as.numeric(c(1, "two", 3))
})

##check even function1
is_even <- function(n){
  n %% 2 == 0
}

is_even(768)

is_even("two")

##alternative 1
is_even_error <- function(n){
  tryCatch(n %% 2 == 0,
           error = function(e){
             FALSE
           })
}
is_even_error(714)
is_even_error("eight")

##alternative 2
is_even_check <- function(n){
  is.numeric(n) && n %% 2 == 0
}
is_even_check(1876)
is_even_check("twelve")

library(microbenchmark)
microbenchmark(sapply(letters, is_even_check))
microbenchmark(sapply(letters, is_even_error))


