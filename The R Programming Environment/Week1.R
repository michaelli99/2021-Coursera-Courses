install.packages("swirl")
packageVersion("swirl")
library(swirl)
install_course("The R Programming Environment")
swirl()

#Introduction
x <- 1
print(x)

x

msg <- "hello"

x <- 11:30
x

#Creating Vectors
x <- c(0.5, 0.6)       ## numeric
x <- c(TRUE, FALSE)    ## logical
x <- c(T, F)           ## logical
x <- c("a", "b", "c")  ## character
x <- 9:29              ## integer
x <- c(1+0i, 2+4i)     ## complex

#Mixing Objects
y <- c(1.7, "a")   ## character
y <- c(TRUE, 2)    ## numeric
y <- c("a", TRUE)  ## character

#Explicit Coersion
x <- 0:6
class(x)
as.numeric(x)
as.logical(x)
as.character(x)

x <- c("a", "b", "c")
as.numeric(x)
as.logical(x)
as.complex(x)

#Matrices
m <- matrix(nrow = 2, ncol = 3) 
m
dim(m)
attributes(m)

m <- matrix(1:6, nrow = 2, ncol = 3) 
m

m <- 1:10 
m
dim(m) <- c(2, 5)
m

x <- 1:3
y <- 10:12
cbind(x, y)
rbind(x, y) 

#Lists
x <- list(1, "a", TRUE, 1 + 4i) 
x
x <- vector("list", length = 5)
x

#Factors
x <- factor(c("yes", "yes", "no", "yes", "no")) 
x
## See the underlying representation of factor
unclass(x) 

x <- factor(c("yes", "yes", "no", "yes", "no"))
x  ## Levels are put in alphabetical order

x <- factor(c("yes", "yes", "no", "yes", "no"),
            levels = c("yes", "no"))
x

#Missing Values
x <- vector(length = 5)
is.na(x)

#Data frames
x <- data.frame(foo = 1:4, bar = c(T, T, F, F)) 
x
nrow(x)
ncol(x)

#Names
x <- 1:3
names(x)
names(x) <- c("New York", "Seattle", "Los Angeles") 
x
names(x)

x <- list("Los Angeles" = 1, Boston = 2, London = 3) 
x
names(x)

m <- matrix(1:4, nrow = 2, ncol = 2)
dimnames(m) <- list(c("a", "b"), c("c", "d")) 
m

colnames(m) <- c("h", "f")
rownames(m) <- c("x", "z")
m

attributes(m)

#Importance of tidydata
library(tidyr)
library(dplyr)

VADeaths %>%
  tbl_df() %>%
  mutate(age = row.names(VADeaths)) %>%
  gather(key, death_rate, -age) %>%
  separate(key, c("urban", "gender"), sep = " ") %>%
  mutate(age = factor(age), urban = factor(urban), gender = factor(gender))

#Reading Tabular Data with the readr Package
library(readr)
teams <- read_csv("C:/Users/micha/OneDrive/Desktop/2021Summer/Programming/data/team_standings.csv",
                  col_types = cols(Standing = col_integer()))

cols(
  Standing = col_integer(),
  Team = col_character()
)
teams

teams <- read_csv("C:/Users/micha/OneDrive/Desktop/2021Summer/Programming/data/team_standings.csv", col_types = "cc")

#Reading web-based data
ext_tracks_file <- paste0("http://rammb.cira.colostate.edu/research/",
                          "tropical_cyclones/tc_extended_best_track_dataset/",
                          "data/ebtrk_atlc_1988_2015.txt")
webdata <- read_csv(ext_tracks_file)
webdata

ext_tracks_widths <- c(7, 10, 2, 2, 3, 5, 5, 6, 4, 5, 4, 4, 5, 3, 4, 3, 3, 3,
                       4, 3, 3, 3, 4, 3, 3, 3, 2, 6, 1)

ext_tracks_colnames <- c("storm_id", "storm_name", "month", "day",
                         "hour", "year", "latitude", "longitude",
                         "max_wind", "min_pressure", "rad_max_wind",
                         "eye_diameter", "pressure_1", "pressure_2",
                         paste("radius_34", c("ne", "se", "sw", "nw"), sep = "_"),
                         paste("radius_50", c("ne", "se", "sw", "nw"), sep = "_"),
                         paste("radius_64", c("ne", "se", "sw", "nw"), sep = "_"),
                         "storm_type", "distance_to_land", "final")

ext_tracks <- read_fwf(ext_tracks_file, 
                       fwf_widths(ext_tracks_widths, ext_tracks_colnames),
                       na = "-99")
ext_tracks[1:3, 17:29]

fwf_empty(ext_tracks_file)

library(dplyr)

ext_tracks %>%
  filter(storm_name == "KATRINA") %>%
  select(month, day, hour, max_wind, min_pressure, rad_max_wind) %>%
  sample_n(4)

zika_file <- paste0("https://raw.githubusercontent.com/cdcepi/zika/master/",
                    "Brazil/COES_Microcephaly/data/COES_Microcephaly-2016-06-25.csv")
zika_brazil <- read_csv(zika_file)

zika_brazil %>%
  select(location, value, unit)

#Requesting data through a web API

library(httr)
meso_url <- "https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py/"
denver <- GET(url = meso_url,
              query = list(station = "DEN",
                           data = "sped",
                           year1 = "2016",
                           month1 = "6",
                           day1 = "1",
                           year2 = "2016",
                           month2 = "6",
                           day2 = "30",
                           tz = "America/Denver",
                           format = "comma")) %>%
  content() %>% 
  read_csv(skip = 5, na = "M") 

denver %>% slice(1:3)
(3 > 5) & (4 == 4)

#Try 4!=4.0
