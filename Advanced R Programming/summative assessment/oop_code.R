# OOP Method: S3
library(readr)
library(magrittr)
library(tidyverse)
## Load any other packages that you may need to execute your code

# Define make_LD function and LongitudinalData class
make_LD <- function(dataframe){
  structure(dataframe, class = "LongitudinalData")
}

# Define subject function and subject class
subject <- function(longit_data, id_num) UseMethod("subject")

subject.LongitudinalData <- function(longit_data, id_num){
  class(longit_data) <- "data.frame"
  sub_data <- longit_data %>% filter(id == id_num)
  
  if(nrow(sub_data) > 0){
    structure(list(id = id_num, data = sub_data), class = "subject")
  }
  else{
    return(NULL)
  }
}

# Define visit function and visit class
visit <- function(subj, visit_num) UseMethod("visit")

visit.subject <- function(subj, visit_num){
  visit_data <- subj$data %>% filter(visit == visit_num)
  if(nrow(visit_data) > 0){
    structure(list(id = subj$id, visit = visit_num, data = visit_data), 
              class = "visit")
  }
  else{
    return(NULL)
  }
}

# Define room function and room class
room <- function(visit_sub, room_type) UseMethod("room")

room.visit <- function(visit_sub, room_type){
  room_data <- visit_sub$data %>% filter(room == room_type)
  if(nrow(room_data) > 0){
    structure(list(id = visit_sub$id, visit = visit_sub$visit, 
                   room = room_type, data = room_data), 
              class = "room")
  }
  else{
    return(NULL)
  }
}

# Define summary functions and summary class
summary.subject <- function(subj){
  if(length(subj$id) > 0){
    df <- subj$data %>% 
      select(visit, room, value) %>%
      group_by(visit, room) %>%
      summarise(value = mean(value)) %>%
      spread(room, value)
    
    structure(list(id = subj$id, summary = df), class = "summary")
  }
  else{
    return(NULL)
  }
}

summary.room <- function(room_data){
  if(nrow(room_data$data) > 0){
    df <- room_data$data$value %>% summary()
    
    structure(list(id = room_data$id, summary = df), class = "summary")
  }
  else{
    return(NULL)
  }
}

# Create print functions for LongitudinalData, subject, summary, and room 
# classes
print.LongitudinalData <- function(x){
  paste("Longitudinal dataset with", length(unique(x$id)),"subjects")
}

print.subject <- function(subj){
  if(length(subj$id) > 0){
    paste("Subject ID:", subj$id)
  }
  else{
    return(NULL)
  }
}

print.summary <- function(smry){
  if(length(smry$id)>0){
    print(paste("ID:", smry$id))
    print(smry$summary)
  }
  else{
    return(NULL)
  }
}

print.room <- function(room_data){
  if(nrow(out$data)>0){
    print(paste("ID:", room_data$id))
    print(paste("Visit:", room_data$visit))
    print(paste("Room: ", room_data$room))
  }
  else{
    return(NULL)
  }
}

## Read in the data
data <- read_csv("MIE.csv")
x <- make_LD(data)
print(class(x))
print(x)

## Subject 10 doesn't exist
out <- subject(x, 10)
print(out)

out <- subject(x, 14)
print(out)

out <- subject(x, 54) %>% summary
print(out)

out <- subject(x, 14) %>% summary
print(out)

out <- subject(x, 44) %>% visit(0) %>% room("bedroom")
print(out)

## Show a summary of the pollutant values
out <- subject(x, 44) %>% visit(0) %>% room("bedroom") %>% summary
print(out)

out <- subject(x, 44) %>% visit(1) %>% room("living room") %>% summary
print(out)
