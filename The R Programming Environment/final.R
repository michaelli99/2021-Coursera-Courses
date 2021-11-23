install.packages(c("dplyr", "tidyr", "readr", "readxl"))
library(tidyverse)

data_address <- paste0("C:/Users/micha/OneDrive/Desktop/2021Summer",
                      "/Programming/1.The R Programming Environment",
                       "/week4_data/daily_SPEC_2014.csv.bz2")

daily_data <- read_csv(data_address)

head(daily_data)

summary(daily_data)

table(daily_data$`Parameter Name`)
table(daily_data$`State Name`)

#Question 1
daily_data %>%
  select(`State Name`, `Parameter Name`, `Arithmetic Mean`) %>%
  filter(`State Name` == "Wisconsin" & 
           `Parameter Name` == "Bromine PM2.5 LC") %>%
  group_by(`State Name`, `Parameter Name`) %>%
  summarise(average = mean(`Arithmetic Mean`, na.rm = TRUE))

#Question 2
daily_data %>%
  group_by(`Parameter Name`) %>%
  filter(`Parameter Name` %in% c("Sodium PM2.5 LC",
                                 "OC CSN Unadjusted PM2.5 LC TOT",
                                 "Sulfur PM2.5 LC",
                                 "EC2 PM2.5 LC")) %>%
  summarise(Average = mean(`Arithmetic Mean`, na.rm = TRUE))

#Question 3
daily_data %>%
  group_by(`Parameter Name`) %>%
  filter(`Parameter Name` == "Sulfate PM2.5 LC" &
         `State Code` %in% c() &
           `County Code` %in% &
           `Site Num` %in% ) %>%
  summarise(Average = mean(`Arithmetic Mean`, na.rm = TRUE))

#QUESTION 4
daily_data %>%
  group_by(`Parameter Name`, `State Name`) %>%
  filter(`Parameter Name` == "EC PM2.5 LC TOR", 
         `State Name` %in% c("California", "Arizona")) %>%
  summarise(Average = mean(`Arithmetic Mean`, na.rm = TRUE))

#QUESTION 5
daily_data %>%
  select(`Parameter Name`, `Arithmetic Mean`, `Longitude`) %>%
  filter(`Parameter Name` == "OC PM2.5 LC TOR", 
         `Longitude` < -100) %>%
  summarise(Average = median(`Arithmetic Mean`, na.rm = TRUE))

#Question 6
data_address2 <- paste0("C:/Users/micha/OneDrive/Desktop/2021Summer/",
                        "Programming/1.The R Programming Environment/",
                        "week4_data/aqs_sites.xlsx")
aqs_data <- read_excel(data_address2)

summary(aqs_data)

aqs_data %>%
  filter(`Land Use` == "RESIDENTIAL",
         `Location Setting` == "SUBURBAN") %>%
  summarise(number = n())

#Question 7

new_data1 <- daily_data %>%
  mutate(`State Code` = as.numeric(`State Code`),
         `County Code` = as.numeric(`County Code`),
         `Site Num` = as.numeric(`Site Num`))

new_data2 <- left_join(new_data1, aqs_data, by = c("Longitude",
                                                   "Latitude"))

`Location Setting` == "SUBURBAN" &
  `Longitude` >= -100 &
  `Parameter Name` == "EC PM2.5 LC TOR")

new_data2 %>%
  filter(  `Longitude` >= -100 &
             `Location Setting` == "SUBURBAN" &
             `Land Use`== "RESIDENTIAL" &
           `Parameter Name` == "EC PM2.5 LC TOR") %>%
  summarise("Median" = median(`Arithmetic Mean`))

##Question 8
%>%
  group_by("Month") %>%
  summarise("Median" = max(`Arithmetic Mean`))

new_data3 <- new_data2 %>%
  select(`Land Use`, `Parameter Name`, `Arithmetic Mean`, `Date Local`) %>%
  filter(`Land Use` == "COMMERCIAL" &
           `Parameter Name` == "Sulfate PM2.5 LC") %>%
  mutate("month_local" = months(`Date Local`)) %>%
  group_by(month_local) %>%
  summarise(average = mean(`Arithmetic Mean`)) %>%
  arrange(desc(average))

##Question 9
new_data4 <- new_data2 %>%
  select(`State Code.x`, `County Code.x`, `Site Num`, `Parameter Name`,
         `Arithmetic Mean`, `Date Local`) %>%
  filter(`State Code.x` == 6 & `County Code.x`== 65 & `Site Num` == 8001 &
           `Parameter Name` %in% c("Sulfate PM2.5 LC", 
                                   "Total Nitrate PM2.5 LC")) %>%
  group_by(`Date Local`, `Parameter Name`) %>%
  summarise(content = mean(`Arithmetic Mean`)) %>%
  group_by(`Date Local`) %>%
  summarise(all_content = sum(content))

##Question 10
new_data5 <- new_data2 %>%
  select(`State Code.x`, `County Code.x`, `Site Num`, `Parameter Name`,
         `Arithmetic Mean`, `Date Local`) %>%
  mutate(location_code = as.numeric(paste0(`State Code.x`, 
                                           `County Code.x`, 
                                           `Site Num`))) %>%
  filter((location_code == 16372) & ##, , 
           (`Parameter Name` == "Total Nitrate PM2.5 LC")) %>% ##"Total Nitrate PM2.5 LC"Sulfate PM2.5 LC
  group_by(location_code, `Date Local`, `Parameter Name`) %>%
  arrange(desc(`Date Local`))

list1 <- new_data5$`Arithmetic Mean`
list2 <- new_data5$`Arithmetic Mean`
list3 <- new_data5$`Arithmetic Mean`
list4 <- new_data5$`Arithmetic Mean`
list5 <- new_data5$`Arithmetic Mean`
list6 <- new_data5$`Arithmetic Mean`
list7 <- new_data5$`Arithmetic Mean`
list8 <- new_data5$`Arithmetic Mean`

cor(list2, list1)
