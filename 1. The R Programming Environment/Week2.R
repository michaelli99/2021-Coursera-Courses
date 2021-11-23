library(tidyverse)
library(ggplot2)
#datasource
ext_tracks_file <- paste0("http://rammb.cira.colostate.edu/research/",
                          "tropical_cyclones/tc_extended_best_track_dataset/",
                          "data/ebtrk_atlc_1988_2015.txt")
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

#piping
##without piping
katrina <- filter(ext_tracks, storm_name == "KATRINA")
katrina_reduced <- select(katrina, month, day, hour, max_wind)
head(katrina_reduced, 3)

##alternative
head(select(filter(ext_tracks, storm_name == "KATRINA"),
            month, day, hour, max_wind), 3)

##piping
ext_tracks %>%
  filter(storm_name == "KATRINA") %>%
  select(month, day, hour, max_wind) %>%
  head(3)

#summarize
ext_tracks %>%
  summarize(n_obs = n(),
            worst_wind = max(max_wind),
            worst_pressure = min(min_pressure))

knots_to_mph <- function(knots){
  mph <- 1.152 * knots
}

ext_tracks %>%
  summarize(n_obs = n(),
            worst_wind = knots_to_mph(max(max_wind)),
            worst_pressure = min(min_pressure))

ext_tracks %>%
  group_by(storm_name, year) %>% ##the group by function does not anything by itself
                                 ##it only group the dataframe by characteristics 
  head()

ext_tracks %>%
  group_by(storm_name, year) %>%
  summarize(n_obs = n(),
            worst_wind = max(max_wind),
            worst_pressure = min(min_pressure))

ext_tracks %>%
  group_by(storm_name) %>%
  summarize(worst_wind = max(max_wind)) %>%
  ggplot(aes(x = worst_wind)) + geom_histogram()

#selecting and filtering the data
##selecting (by column)
ext_tracks %>%
  select(storm_name, month, day, hour, year, latitude, longitude, max_wind)

ext_tracks %>%
  select(storm_name, latitude, longitude, starts_with("radius_34") & ends_with("_sw"))

##filtering (rows)
head(ext_tracks$hour, 10)
head(ext_tracks$hour == "00",100)
ext_tracks %>%
  select(storm_name, hour, max_wind) %>%
  filter(hour == "00") %>%
  head(10)

ext_tracks %>%
  group_by(storm_name, year) %>%
  summarize(worst_wind = max(max_wind)) %>%
  filter(worst_wind >= 160)

ext_tracks %>%
  select(storm_name, month, day, hour, latitude, longitude, max_wind) %>%
  filter(storm_name == "ANDREW" & max_wind >= 137) 

#adding changing renaming
library(faraway)
data(worldcup)

##change rownames to variables
worldcup <- worldcup %>%
  mutate(player_name = rownames(worldcup))

worldcup %>% slice(1:3)

##create new column
worldcup <- worldcup %>% 
  group_by(Position) %>% ##group by will cause the result df to be ordered by Position
  mutate(ave_shots = mean(Shots)) %>%
  ungroup()              ##return to original order

worldcup %>% slice(1:3)

##rename the row name
worldcup %>% 
  rename(Name = player_name) %>%
  slice(1:3)

#spreading and gathering data
data("VADeaths")
head(VADeaths)

class(VADeaths)

VADeaths  <- VADeaths %>%
  tbl_df() %>%            #coerce the class from matrix into df
  mutate(age = row.names(VADeaths))

## Gather everything but age to tidy data
VADeaths %>%
  gather(key = key, value = death_rate, -age)

##alternative way (pivot_longer)
VADeaths %>%
  pivot_longer(
    cols = colnames(VADeaths)[1:4],
    names_to = "key",
    values_to = "death_rate",
  )

worldcup %>%
  select(Position, Time, Shots, Tackles, Saves) %>% 
  gather(Type, Number, -Position, -Time) %>%
  ggplot(aes(x = Time, y = Number)) + 
  geom_point() + 
  facet_grid(Type ~ Position)

##spreading data (alternative pivot_wider)
library(knitr)
wc_table <- worldcup %>% 
  filter(Team %in% c("Spain", "Netherlands", "Uruguay", "Germany")) %>%
  select(Team, Position, Passes) %>%
  group_by(Team, Position) %>%
  summarize(ave_passes = mean(Passes),
            min_passes = min(Passes),
            max_passes = max(Passes),
            pass_summary = paste0(round(ave_passes), " (", 
                                  min_passes, ", ",
                                  max_passes, ")")) %>%
  select(Team, Position, pass_summary)
# What the data looks like before using `spread`
wc_table
wc_table %>%
  spread(Position, pass_summary) ##%>%
##  kable()

#Merging datasets
team_standings <- read_csv(paste("C:/Users/micha/OneDrive/Desktop/2021Summer",
                                 "/Programming/data/team_standings.csv",
                                 sep = "")
                           )
team_standings %>% slice(1:3)

left_join(worldcup, team_standings, by = 'Team')

worldcup <- worldcup %>%
  rename(Team = Team_name)
worldcup

data(worldcup)
worldcup %>% 
  mutate(Name = rownames(worldcup),
         Team = as.character(Team)) %>%
  select(Name, Position, Shots, Team) %>%
  arrange(desc(Shots)) %>%
  slice(1:20) %>%
  left_join(team_standings, by = "Team") %>% # Merge in team standings
  rename("Team Standing" = Standing) %>%
  kable()

#working with dates, times, time zones
##converting to a date
library(lubridate)
andrew_tracks <- ext_tracks %>%
  filter(storm_name == "ANDREW" & year == "1992") %>%
  select(year, month, day, hour, max_wind, min_pressure) %>%
  unite(datetime, year, month, day, hour) %>%
  mutate(datetime = ymd_h(datetime))

head(andrew_tracks, 3)

andrew_tracks %>%
  gather(measure, value, -datetime) %>%
  ggplot(aes(x = datetime, y = value)) + 
  geom_point() + geom_line() + 
  facet_wrap(~ measure, ncol = 1, scales = "free_y")

##Pulling out date and time elements
andrew_tracks %>%
  select(datetime) %>%
  mutate(year = year(datetime),
         month = months(datetime),
         weekday = weekdays(datetime),
         yday = yday(datetime),
         hour = hour(datetime)) %>%
  slice(1:3)

check_tracks <- ext_tracks %>%
  select(month, day, hour, year, max_wind) %>%
  unite(datetime, year, month, day, hour) %>%
  mutate(datetime = ymd_h(datetime),
         weekday = weekdays(datetime),
         weekday = factor(weekday, levels = c("Sunday", "Monday",
                                              "Tuesday", "Wednesday",
                                              "Thursday", "Friday",
                                              "Saturday")),
         month = months(datetime),
         month = factor(month, levels = c("April", "May", "June",
                                          "July", "August", "September",
                                          "October", "November", 
                                          "December", "January")))
check_weekdays <- check_tracks %>%
  group_by(weekday) %>%
  summarize(ave_max_wind = mean(max_wind)) %>%
  rename(grouping = weekday)
check_months <- check_tracks %>%
  group_by(month) %>%
  summarize(ave_max_wind = mean(max_wind)) %>%
  rename(grouping = month)

a <- ggplot(check_weekdays, aes(x = grouping, y = ave_max_wind)) + 
  geom_bar(stat = "identity") + xlab("")
b <- a %+% check_months

library(gridExtra)
grid.arrange(a, b, ncol = 1)

##time zones
andrew_tracks <- ext_tracks %>%
  filter(storm_name == "ANDREW") %>% 
  slice(23:47) %>%
  select(year, month, day, hour, latitude, longitude) %>%
  unite(datetime, year, month, day, hour) %>%
  mutate(datetime = ymd_h(datetime),
         date = format(datetime, "%b %d")) 

library(ggmap)
miami <- get_map('miami', zoom = 5)
ggmap(miami) + 
  geom_path(data = andrew_tracks, aes(x = -longitude, y = latitude),
            color = "gray", size = 1.1) + 
  geom_point(data = andrew_tracks,
             aes(x = -longitude, y = latitude, color = date),
             size = 2)

andrew_tracks <- andrew_tracks %>%
  mutate(datetime = with_tz(datetime, tzone = "America/New_York"),
         date = format(datetime, "%b %d")) 

ggmap(miami) + 
  geom_path(data = andrew_tracks, aes(x = -longitude, y = latitude),
            color = "gray", size = 1.1) + 
  geom_point(data = andrew_tracks,
             aes(x = -longitude, y = latitude, color = date),
             size = 2)
