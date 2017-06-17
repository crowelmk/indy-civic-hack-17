setwd("C:/Users/Kanishka/indy-civic-hack-17_1/")
library(tidyverse)
library(dplyr)
library(extrafont)
library(kani)
library(plotly)

options(scipen = 99)

light_red = "#f8766d"
light_blue = "#00bfc4"

data_years <- read.csv("data_all_years.csv")
teen_births <- read.csv("teen_births.csv")

counties <- data_years %>%
  mutate(County = County.Name) %>%
  select(-County.Name)

county_teen_births <- counties %>%
  inner_join(teen_births %>% select(-c(X)), by = c("County", "year"))

fund_names <- county_teen_births %>%
  group_by(Fund.Name) %>%
  summarize(counts = n())

# county_teen_births_years <- county_teen_births %>%
#   group_by(County, year, Unit_Type_Name, Fund.Name) %>%
#   summarize(total = )

counties <- counties[complete.cases(counties),]
  
county_teen_births <- counties %>%
  inner_join(teen_births %>% select(-c(X)), by = c("County", "year"))

county_teen_birth_years <-
  county_teen_births %>%
  filter(Unit_Type_Name %in% c("County", "School")) %>%
  group_by(year, County, Unit_Type_Name) %>%
  summarise(budget = sum(Budget),
            teen_births = sum(Teen.Births))

state_teen_births <- county_teen_births %>%
  group_by(year) %>%
  summarise(budget = sum(Budget),
            teen_births = mean(Teen.Births))

state_teen_births %>%
  ggplot(aes(year, teen_births)) + 
  geom_point() + 
  geom_line(aes(group = 1))

county_county_spend <- county_teen_births %>%
  filter(Unit_Type_Name %in% c("County", "School")) %>%
  group_by(year, Unit_Type_Name) %>%
  summarise(budget = sum(Budget))

county_county_spend %>%
  ggplot(aes(year, budget, color = Unit_Type_Name)) +
  geom_point() + 
  geom_line(aes(group = Unit_Type_Name))



teen_births_per_year <- county_teen_births %>%
  filter(Unit_Type_Name %in% c("County", "School")) %>%
  group_by(year, Unit_Type_Name) %>%
  summarize(billion_spent = sum(Budget)/(10^9),
            teen_births = mean(Teen.Birth.Rate),
            births_per_billion = teen_births/billion_spent)

p <- teen_births_per_year %>%
  ggplot(aes(year, births_per_billion, color = Unit_Type_Name)) + 
  geom_point() + 
  geom_line(aes(group = Unit_Type_Name), size = 1.5)

plotly::ggplotly(p)


total <- county_teen_births %>%
  group_by(year, County) %>%
  summarize(millions_spent = sum(Budget)/(10^6),
            teen_birth_rate = mean(Teen.Birth.Rate)) %>%
  mutate(Unit_Type = "Total",
         rate_score = teen_birth_rate/millions_spent)

total_school <- county_teen_births %>%
  filter(Unit_Type_Name == "School") %>%
  group_by(year, County) %>%
  summarise(millions_spent = sum(Budget)/(10^6),
            teen_birth_rate = mean(Teen.Birth.Rate)) %>%
  mutate(Unit_Type = "School",
         rate_score = teen_birth_rate/millions_spent)

county_teen_birth_spend <- rbind(total, total_school)

school_scores <- total_school %>%
  select(-c(millions_spent, teen_birth_rate)) %>%
  spread(key = year, value = rate_score)

total_scores <- total %>%
  select(-c(millions_spent, teen_birth_rate)) %>%
  spread(key = year, value = rate_score)

good_totals <- total_scores %>%
  mutate(diff_2011_12 = `2011` - `2012`) %>%
  top_n(10, diff_2011_12) %>%
  arrange(desc(diff_2011_12))

bad_totals <- total_scores %>%
  mutate(diff_2011_12 = `2011` - `2012`) %>%
  top_n(10, -diff_2011_12) %>%
  arrange(-diff_2011_12)


top_10 <- rbind(good_totals, bad_totals) %>%
  mutate(change = ifelse(diff_2011_12 < 0, "Worsened", "Improved"))  

top_10_plot <- top_10 %>%
  mutate(County = reorder(County, diff_2011_12)) %>%
  ggplot(aes(diff_2011_12, County, color = change)) +
  geom_segment(aes(y = County, yend = County, x = 0, xend = diff_2011_12), size = 2, alpha = 0.7) + 
  geom_point(size = 3) +
  geom_point(size = 5.5, alpha = 0.4) +
  geom_vline(xintercept = 0, lty = 1, size = 1) +
  scale_color_manual(values = c(light_blue, light_red)) +
  scale_x_continuous(breaks = seq(-0.2,0.6, by = 0.1)) + 
  theme_kani() + 
  labs(title = "Top 10 Counties that have improved/worsened between 2011 and 2012")
top_10_plot

plotly::ggplotly(top_10_plot)

plot_ly(top_10, x = ~County, y = ~diff_2011_12, type = "bar")
  


counties <- counties %>%
  group_by(year, County, Unit_Type_Name) %>%
  summarize(budget_total = sum(Budget)) %>%
  inner_join(counties)
  
counties_perc <- counties %>%
  group_by(year, County, Unit_Type_Name, Fund.Name) %>%
  summarize(fund_budget = sum(Budget)) %>%
  inner_join(counties) %>%
  mutate(perc_budget = fund_budget/budget_total)

counties_unit_type_name <- counties %>%
  group_by(year, County, Unit_Type_Name, Unit.Name) %>%
  summarise(budget_unitname_total = sum(Budget)) %>%
  inner_join(counties)


counties_all_budget <- counties_perc %>%
  inner_join(counties_unit_type_name) %>%
  mutate(perc_budget_unitname = Budget/budget_unitname_total)

county_metrics <- counties %>%
  inner_join(main_data, by = c("County", "year"))

### 

write.csv(county_metrics, "county_metrics.csv", row.names = F)
