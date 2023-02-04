#load data
df<-read.csv("https://raw.githubusercontent.com/sulanyang/data-management-teaching/main/cohort%20data.csv")
df_covid<-read.csv("https://raw.githubusercontent.com/sulanyang/data-management-teaching/main/covid%20data.csv")

#load library
library(tidyverse)
library(lubridate)

#data wrangling
df<-df %>%
  mutate (age_b  = ifelse(is.na(age_b),age_b_m, age_b),
          gender = ifelse(is.na(gender),gender_m, gender),
          race   = ifelse(is.na(race),race_m, race)) %>%
  select (-(ends_with("_m"))) %>%
  rename (wgt = wgt_b, 
          hgt = hgt_b, 
          age = age_b, 
          visit=redcap_event_name) %>%
  mutate (date_taken = dmy(date_taken),
          visit = as_factor(visit),
          visit = fct_recode(visit, 
                             "baseline" = "baseline_arm_1", 
                             "6m" = "6_month_followup_arm_1" )) %>%
  group_by(id) %>%
  mutate (wgt = mean(wgt, na.rm=TRUE),
          hgt = mean(hgt, na.rm=TRUE),
          age = mean(age, na.rm=TRUE),
          gender = mean(gender, na.rm=TRUE),
          race = mean(race, na.rm=TRUE)) %>%
  ungroup (.) %>%
  pivot_wider (names_from=visit, 
               values_from=c(date_taken, snab, snab_result),
               names_vary = "slowest")

df<- df %>% left_join(df_covid, by = "id")

####answer from exercise####
df<- df %>%
  mutate (rt_date = dmy(rt_date),
          bmi = wgt/(hgt^2/10000),
          bmi_cat = case_when(bmi < 18.5 ~ "Underweight",
                              between(bmi,18.5,25) ~ "Healthy weight",
                              between(bmi,25,30) ~ "Overweight",
                              bmi >=30 ~ "Obesity"),
          race    = case_when(race==1 ~ "Malay",
                              race==2 ~ "Chinese",
                              race==3 ~ "Indian",
                              race==99 ~ "Others"),
          rt_results = case_when(rt_results==1 ~ "Positive",
                                 rt_results==2 ~ "Negative",
                                 TRUE ~ NA_character_),
          datediff = as.numeric(rt_date - date_taken_baseline)) %>%
  relocate(bmi, bmi_cat, .after = hgt)

#split df into df1 and df2
df1 <- df %>% filter (id %% 2 ==1)
df2 <- df %>% filter (id %% 2 ==0)
dfcomb <- bind_rows(df1, df2)
            
#analyze snab_6m
df %>% group_by(bmi_cat) %>% summarize (n = n(),
                                       mean = mean(snab_6m, na.rm=T),
                                       sd = sd(snab_6m, na.rm=T),
                                       median = median(snab_6m, na.rm=T),
                                       iqr = IQR(snab_6m, na.rm=T))
            
df %>% group_by(race) %>% summarize (n = n(),
                                       mean = mean(snab_6m, na.rm=T),
                                       sd = sd(snab_6m, na.rm=T),
                                       median = median(snab_6m, na.rm=T),
                                       iqr = IQR(snab_6m, na.rm=T))

#analyze t-test 
t.test(df$snab_baseline, df$snab_6m, var.equal = TRUE)            
            
#antjoin to find out who did not have any rapid test
#have to use the df before we do [df<- df %>% left_join(df_covid, by = "id")] at Line 33
noRT<-anti_join(df, df_covid)
            
#ggplot snab vs bmi, color snab by baseline or 6m visit
df %>%
  #this scatter plot requires long data format
  pivot_longer(cols = c("snab_baseline","snab_6m"),
               names_to = "visit",
               values_to = "snab") %>%
  #remove when bmi_cat and snab is NA
  filter(!is.na(bmi_cat),!is.na(snab)) %>%
  #plotting
  ggplot(., aes(x= bmi_cat, y = snab, color=visit)) + 
  geom_point()
  
          