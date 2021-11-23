#Text manipulation function
paste("Square", "Circle", "Triangle")
paste("Square", "Circle", "Triangle", sep = "+")
paste("Square", "Circle", "Triangle", sep = "")
paste0("Square", "Circle", "Triangle")

shapes <- c("Square", "Circle", "Triangle")
paste("My favorite shape is a", shapes)

two_cities <- c("best", "worst")
paste("It was the", two_cities, "of times.")

paste(shapes, collapse = " ")

nchar("Supercalifragilisticexpialidocious")

cases <- c("CAPS", "low", "Title")
tolower(cases)

toupper(cases)

#Regular expressions
regular_expression <- "a"
string_to_search <- "Maryland"

grepl(regular_expression, string_to_search)

regular_expression <- "u"
grepl(regular_expression, string_to_search)

grepl("ryla", "Maryland")
grepl("Marly", "Maryland")

head(state.name)

grepl(".", "Maryland")
grepl(".", "*&2[0+,%<@#~|}")
grepl(".", "")

grepl("a.b", c("aaa", "aab", "abb", "ba", "adcab"))

## Does "Maryland" contain one or more of "a" ?
grepl("a+", "Maryland")

## Does "Maryland" contain one or more of "x" ?
grepl("x+", "Maryland")

## Does "Maryland" contain zero or more of "x" ?
grepl("x*", "Maryland")

## Does "Mississippi" contain 2 adjacent "s" ? (whether contain "ss")
grepl("s{2}", "Mississippi")

## This is equivalent to the expression above:
grepl("ss", "Mississippi")

## Does "Mississippi" contain between 1 and 3 adjacent "s" ?
grepl("s{2,3}", "Mississippi")

## Does "Mississippi" contain between 1 and 3 adjacent "i" ?
grepl("i{2,3}", "Mississippi")

## Does "Mississippi" contain 2 adjacent "iss" ?
grepl("(iss){2}", "Mississippi")

## Does "Mississippi" contain between 2 adjacent "ss" ?
grepl("(ss){2}", "Mississippi")

## Does "Mississippi" contain the pattern of an "i" followed by 
## 2 of any character, with that pattern repeated three times adjacently?
grepl("(i.{2}){3}", "Mississippi")

grepl("\\w", "abcdefghijklmnopqrstuvwxyz0123456789")

grepl("\\d", "0123456789")

# "\n" this regex for a new line and "\t" is the regex for a tab

grepl("\\s", "\n\t   ")
grepl("\\d", "abcdefghijklmnopqrstuvwxyz")
grepl("\\D", "abcdefghijklmnopqrstuvwxyz")
grepl("\\w", "\n\t   ")

grepl("[aeiou]", "rhythms")
grepl("[^aeiour]", "rhythms")
grepl("[a-m]", "xyz")
grepl("[a-m]", "ABC")
grepl("[a-mA-M]", "ABC")

grepl("\\+", "tragedy + time = humor")
grepl("\\.", "http://www.jhsph.edu/")

grepl("^a", c("bab", "aab"))
grepl("b$", c("bab", "aab"))
grepl("^[ab]+$", c("bab", "aab", "abc")) ##a or b from beginning to the end

grepl("a|b", c("abc", "bcd", "cde"))
grepl("North|South", c("South Dakota", "North Carolina", "West Virginia"))

start_end_vowel <- "^[AEIOU]{1}.+[aeiou]{1}$"
vowel_state_lgl <- grepl(start_end_vowel, state.name)
head(vowel_state_lgl)

state.name[vowel_state_lgl]

grepl("^[ab]+", c("bab", "aab", "abc"))
grepl("^a$", c("bab", "aaba", "abc"))
grepl("^ab+", c("bab", "aab", "abc"))
grepl("^[ab]", c("bab", "aab", "abc"))

grepl("[Ii]", c("Hawaii", "Illinois", "Kentucky"))

grep("[Ii]", c("Hawaii", "Illinois", "Kentucky"))

sub("[Ii]", "1", c("Hawaii", "Illinois", "Kentucky"))

gsub("[Ii]", "1", c("Hawaii", "Illinois", "Kentucky"))

two_s <- state.name[grep("ss", state.name)]
two_s

##stringr package
strsplit(two_s, "ss")

library(stringr)

state_tbl <- paste(state.name, state.area, state.abb)
head(state_tbl)

str_extract(state_tbl, "[0-9]+")

head(state.name)

str_order(state.name) #returns a numeric vector that corresponds to the 
                      #alphabetical order
head(state.abb)

str_order(state.abb)

str_pad("Thai", width = 8, side = "left", pad = "-")

str_pad("Thai", width = 8, side = "right", pad = "-")

str_pad("Thai", width = 8, side = "both", pad = "-")

cases <- c("CAPS", "low", "Title")

str_to_title(cases)

to_trim <- c("   space", "the    ", "    final frontier  ")
str_trim(to_trim)

pasted_states <- paste(state.name[1:20], collapse = " ")

cat(str_wrap(pasted_states, width = 18))

cat(str_wrap(pasted_states, width = 30))

a_tale <- "It was the best of times it was the worst of times it was the age of wisdom it was the age of foolishness"

word(a_tale, 2)
word(a_tale, end = 3)
word(a_tale, start = 11, end = 15)

#The Role of Physical Memory
library(pryr)

mem_used()

ls() #show list of objects in current workplace

library(magrittr)

sapply(ls(), function(x) object_size(get(x))) %>% sort %>% tail(5)

rm(ext_tracks)

mem_used()

mem_change(rm(check_tracks, denver, b))

object_size(integer(0))

object_size(integer(1000))  ## 4 bytes per integer

object_size(numeric(1000))  ## 8 bytes per numeric

str(.Machine)

gc() #garbage collection



