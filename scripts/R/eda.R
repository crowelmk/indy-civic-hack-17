setwd("C:/Users/Kanishka/indy-civic-hack-17/")

library(tidyverse)
library(readxl)
library(xlsx)
library(stringr)

primaries <- read.csv("primary_results.csv")

indiana <- primaries %>%
  filter(state_abbreviation == "IN")

write.csv(indiana, "indiana_primary.csv", row.names = F)

county_facts <- read.csv("county_facts.csv")

data_2011 <- read.csv("budget/2011_Budget.csv") %>% mutate(year = "2011")
data_2012 <- read.csv("budget/2012_Certified_Budget_Detai_by_Unit.csv") %>% mutate(year = "2012")
data_2013 <- read.csv("budget/2013_budget.csv") %>% mutate(year = "2013")
data_2014 <- read.csv("budget/2014_budget.csv") %>% mutate(year = "2014")
data_2015 <- read.csv("budget/2015_budget.csv") %>% mutate(year = "2015")
data_2016 <- read.csv("budget/2016_budget.csv") %>% mutate(year = "2016")
data_2017 <- read.csv("budget/2017_budget.csv") %>% mutate(year = "2017")



clean_data <- function(df) {
  colnames(df)[9] <- "Budget"
  colnames(df)[4] <- "Unit_Type_Name"
  colnames(df)[5] <- "Unit"
  df <- df %>%
    mutate(Budget = gsub("-", NA, Budget)) %>%
    mutate(Budget = gsub("$", "", Budget)) %>%
    mutate(Budget = gsub(",", "", Budget)) %>%
    mutate_all(trimws)
  df <- df %>%
    select(year, County:Budget)
  return(df)
}

test <- clean_data(data_2011)

data_2011 <- data_2011 %>%
  clean_data()
data_2012 <- data_2012 %>%
  clean_data()
data_2013 <- data_2013 %>%
  clean_data()
data_2014 <- data_2014 %>%
  clean_data()
data_2015 <- data_2015 %>%
  clean_data()
data_2016 <- data_2016 %>%
  clean_data()
data_2017 <- data_2017 %>%
  clean_data()




data_2017 %>% head() %>% mutate(Budget = gsub("$", "", Budget))
colnames(data_2011)
colnames(data_2015)

data_2015 <- data_2015 %>%
  mutate(Budget = str_sub(Budget, 2, -1))

data_2016 <- data_2016 %>%
  mutate(Budget = str_sub(Budget, 2, -1))

data_2017 <- data_2017 %>%
  mutate(Budget = str_sub(Budget, 2, -1))

data_2011 <- data_2011 %>%
  mutate(Budget = as.numeric(Budget))
data_2012 <- data_2012 %>%
  mutate(Budget = as.numeric(Budget))
data_2013 <- data_2013 %>%
  mutate(Budget = as.numeric(Budget))
data_2014 <- data_2014 %>%
  mutate(Budget = as.numeric(Budget))
data_2015 <- data_2015 %>%
  mutate(Budget = as.numeric(Budget))
data_2016 <- data_2016 %>%
  mutate(Budget = as.numeric(Budget))
data_2017 <- data_2017 %>%
  mutate(Budget = as.numeric(Budget))


data_years <- rbind(data_2011, data_2012, data_2013, data_2014, data_2015, data_2016, data_2017)

write.csv(data_years, "data_all_years.csv", row.names = F)



