#Object Oriented Programming
##S3
class(2)

class("is in session.")

class(class)

special_num_1 <- structure(1, class = "special_number")
class(special_num_1)

special_num_2 <- 2
class(special_num_2)

class(special_num_2) <- "special_number"
class(special_num_2)

shape_s3 <- function(side_lengths){
  structure(list(side_lengths = side_lengths), class = "shape_S3")
}

square_4 <- shape_s3(c(4, 4, 4, 4))
class(square_4)

triangle_3 <- shape_s3(c(3, 3, 3))
class(triangle_3)

triangle_4 <- shape_s3(c(4, 4, 4))
class(triangle_4)

mean(c(2, 3, 7))

mean(c(as.Date("2016-09-01"), as.Date("2016-09-03")))

is_square <- function(x) UseMethod("is_square")

is_square.shape_S3 <- function(x){
  length(x$side_lengths) == 4 &&
    x$side_lengths[1] == x$side_lengths[2] &&
    x$side_lengths[2] == x$side_lengths[3] &&
    x$side_lengths[3] == x$side_lengths[4]
}
is_square(square_4)
is_square(triangle_3)

is_square.default <- function(x){
  NA
}

is_square("square")

is_square(c(1, 1, 1, 1))

is_square(shape_s3(c(1, 1, 1, 1)))

print(square_4)

print.shape_S3 <- function(x){
  if(length(x$side_lengths) == 3){
    paste("A triangle with side lengths of", x$side_lengths[1], 
          x$side_lengths[2], "and", x$side_lengths[3])
  } else if(length(x$side_lengths) == 4) {
    if(is_square(x)){
      paste("A square with four sides of length", x$side_lengths[1])
    } else {
      paste("A quadrilateral with side lengths of", x$side_lengths[1],
            x$side_lengths[2], x$side_lengths[3], "and", x$side_lengths[4])
    }
  } else {
    paste("A shape with", length(x$side_lengths), "slides.")
  }
}

print(square_4)

print(triangle_3)

print(shape_s3(c(10, 10, 20, 20, 15)))

print(shape_s3(c(2, 3, 4, 5)))

head(methods(print), 10)

class(square_4)

class(square_4) <- c("shape_S3", "four")

class(square_4)

inherits(triangle_3, "square")

##S4
setClass("bus_S4",
         slots = list(n_seats = "numeric", 
                      top_speed = "numeric",
                      current_speed = "numeric",
                      brand = "character"))
setClass("party_bus_S4",
         slots = list(n_subwoofers = "numeric",
                      smoke_machine_on = "logical"),
         contains = "bus_S4")
my_bus <- new("bus_S4", n_seats = 20, top_speed = 80, 
              current_speed = 0, brand = "Volvo")
my_bus

my_party_bus <- new("party_bus_S4", n_seats = 10, top_speed = 100,
                    current_speed = 0, brand = "Mercedes-Benz", 
                    n_subwoofers = 2, smoke_machine_on = FALSE)
my_party_bus

my_bus@n_seats

my_party_bus@top_speed

setGeneric("is_bus_moving", function(x){
  standardGeneric("is_bus_moving")
})

setMethod("is_bus_moving",
          c(x = "bus_S4"),
          function(x){
            x@current_speed > 0
          })

is_bus_moving(my_bus)

my_bus@current_speed <- 1
is_bus_moving(my_bus)

setGeneric("print")
setMethod("print",
          c(x = "bus_S4"),
          function(x){
            paste("This", x@brand, "bus is traveling at a speed of", x@current_speed)
          })

print(my_bus)

print(my_party_bus)

##references classes
Student <- setRefClass("Student",
                       fields = list(name = "character",
                                     grad_year = "numeric",
                                     credits = "numeric",
                                     id = "character",
                                     courses = "list"),
                       methods = list(
                         hello = function(){
                           paste("Hi! My name is", name)
                         },
                         add_credits = function(n){
                           credits <<- credits + n
                         },
                         get_email = function(){
                           paste0(id, "@jhu.edu")
                         }
                       ))

brooke <- Student$new(name = "Brooke", grad_year = 2019, credits = 40,
                      id = "ba123", courses = list("Ecology", "Calculus III"))
roger <- Student$new(name = "Roger", grad_year = 2020, credits = 10,
                     id = "rp456", courses = list("Puppetry", "Elementary Algebra"))
brooke$credits
roger$hello()
roger$get_email()

brooke$credits
brooke$add_credits(4)
brooke$credits

Grad_Student <- setRefClass("Grad_Student",
                            contains = "Student",
                            fields = list(thesis_topic = "character"),
                            methods = list(
                              defend = function(){
                                paste0(thesis_topic, ". QED.")
                              }
                            ))

jeff <- Grad_Student$new(name = "Jeff", grad_year = 2021, credits = 8,
                         id = "jl55", courses = list("Fitbit Repair", 
                                                     "Advanced Base Graphics"),
                         thesis_topic = "Batch Effects")

jeff$defend()


