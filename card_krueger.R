install.packages(c("tidyverse", "haven", "fixest", "knitr", "kableExtra","plm"))
library(tidyverse)
library(kableExtra)
library(fixest)      
library(knitr)
tempfile_path <- tempfile()
download.file("http://davidcard.berkeley.edu/data_sets/njmin.zip", destfile = tempfile_path)
tempdir_path <- tempdir()
unzip(tempfile_path, exdir = tempdir_path)
codebook <- read_lines(file = paste0(tempdir_path, "/codebook"))

variable_names <- codebook %>%
  `[`(8:59) %>%
  `[`(-c(5, 6, 13, 14, 32, 33)) %>%
  str_sub(1, 13) %>%
  str_squish() %>%
  str_to_lower()

dataset <- read_table(
  paste0(tempdir_path, "/public.dat"),
  col_names = FALSE,
  show_col_types = FALSE
)

dataset <- dataset %>%
  select(-X47) %>%
  `colnames<-`(., variable_names) %>%
  mutate_all(as.numeric) %>%
  mutate(sheet = as.character(sheet))


write.csv(dataset,file="fast-food-data.csv")
names(dataset)

df <- dataset %>% 
  mutate(
    # 1 = New Jersey, 0 = Pennsylvania
    treat = ifelse(state == 1, 1, 0),
    
    # full-time-equivalent workers, before and after
    fte_w1 = empft  + nmgrs  + 0.5 * emppt,
    fte_w2 = empft2 + nmgrs2 + 0.5 * emppt2,
    
    delta  = fte_w2 - fte_w1
  ) %>% 

  filter(!is.na(fte_w1) & !is.na(fte_w2))

#table 3 

table3 <- df %>% 
  group_by(treat) %>% 
  summarise(
    mean_w1 = mean(fte_w1),
    mean_w2 = mean(fte_w2),
    change  = mean(delta),
    .groups = "drop"
  ) %>% 
  mutate(state = ifelse(treat == 1, "NJ", "PA")) %>% 
  relocate(state)

did <- with(table3, change[state == "NJ"] - change[state == "PA"])

kable(table3, digits = 2, caption = "Replication of Card–Krueger Table 3") %>% 
  kable_classic(full_width = FALSE)

print(paste("Difference-in-Differences (NJ − PA):",
            round(did, 2), "FTE workers per restaurant"))
#table 4 column i

df_table4 <- df %>%
  filter(
    !is.na(wage_st),
    !is.na(wage_st2)
  )

m1 <- feols(delta ~ treat, data = df_table4)

summary(m1)


#table 4 column iii

df_m3 <- df %>%
  filter(!is.na(wage_st)) %>%
  mutate(
    gap = ifelse(
      treat == 1 & wage_st < 5.05,
      (5.05 - wage_st) / wage_st,
      0
    )
  )

m3 <- feols(delta ~ gap, data = df_m3)

summary(m3)

#summary in a table

etable(
  m1, m3,
  digits = 2,
  tex = F,
  headers = c(
    "(i) ΔEmployment ~ NJ dummy",
    "(iii) ΔEmployment ~ Wage gap"
  )
)

