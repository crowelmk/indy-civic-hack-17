setwd("C:/Users/Kanishka/indy-civic-hack-17_1/")
library(tidyverse)
library(dplyr)
library(extrafont)
library(kani)
library(plotly)
library(stringr)

light_red = "#f8766d"
light_blue = "#00bfc4"

data_years <- read.csv("data_all_years.csv")
main_data <- read.csv("main_data.csv")
colnames(main_data)[1] <- "children_in_poverty"
colnames(main_data)[2] <- "Low_Birthweight"
colnames(main_data)[4] <- "graduation_rate"
colnames(main_data)[5] <- "teen_birth_rate"
colnames(main_data)[6] <- "teen_birth"


metric_years <- main_data %>% inner_join(data_years %>% mutate(County = County.Name) %>% select(County, year, Unit_Type_Name, Budget), on = c("County", "year"))

metric_years <- metric_years[complete.cases(metric_years),]
metric_totals <- metric_years %>%
  group_by(year, County) %>%
  summarise(millions_spent = sum(Budget)/(10^6),
            chi_poverty_score = mean(children_in_poverty)/millions_spent,
            lbw_score = mean(Low_Birthweight)/millions_spent,
            grad_score = mean(graduation_rate)/millions_spent,
            teen_birth_score = mean(teen_birth_rate)/millions_spent)


long_lat <- map_data("county") %>%
  filter(region == 'indiana')

long_lat <- long_lat %>%
  mutate(subregion = paste(toupper(str_sub(subregion, 1, 1)),str_sub(subregion, 2,-1), sep = "")) %>%
  mutate(County = subregion) %>%
  select(-subregion) %>%
  inner_join(metric_2011, by = "County")

long_lat$teen_score <- cut(long_lat$teen_birth_score, breaks = c(seq(0.018, 3.6, length.out = 9)), labels=1:8)

metric_2011 <- metric_totals %>% filter(year == "2011")
p <- long_lat %>%
  group_by(group) %>%
  plot_ly(x = ~long,
    y = ~lat,
    color = ~teen_score, colors = c('#ffeda0','#f03b20'),
    text = ~County, hoverinfo = 'text', height = 700, width = 700) %>%
  add_polygons(line = list(width = 0.4)) %>%
  add_polygons(
    fillcolor = 'transparent',
    line = list(color = 'black', width = 0.5),
    showlegend = FALSE, hoverinfo = 'none'
  ) %>%
  layout(
    title = "Indiana Stuff..",
    titlefont = list(size = 12),
    xaxis = list(title = "", showgrid = FALSE,
                 zeroline = FALSE, showticklabels = FALSE),
    yaxis = list(title = "", showgrid = FALSE,
                 zeroline = FALSE, showticklabels = FALSE)
  )

p
