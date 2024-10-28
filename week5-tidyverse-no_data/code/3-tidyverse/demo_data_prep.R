# demo_data_prep.R
# 17.10.24
# Merging demographic and sample information into the body measurements data

library(tidyverse)
library(haven)

# Read in demographic data from SAS file
demo_data <- read_xpt("../../data/original/DEMO_D.XPT")

View(demo_data)

# Select participant ID, gender, age in months, ethnicity
demog <- demo_data |> 
  select(SEQN, RIAGENDR, RIDAGEMN, RIDRETH1)

# Read in the body measurement data
bmx_d <- read_csv("../../data/original/BMX_D.csv")

# Clean variable names
bmx_d_clean <- bmx_d |> 
  janitor::clean_names() |> 
  select(!x1)

demog_clean <- demog |> 
  janitor::clean_names()

# Merge in demographic data and relocate variables
bmx_d_demog <- bmx_d_clean |>
  left_join(demog_clean) |> 
  relocate(riagendr, ridagemn, ridreth1, .before = 2)

# Read in the sample file and merge
sample_info <- read_csv("../../data/derived/sample.csv")

sample_info_clean <- sample_info |> 
  janitor::clean_names() |> 
  select(!x1)

bmx_d_demog_smp <- bmx_d_demog |> 
  left_join(sample_info_clean) |> 
  relocate(in_sample = insample, .after = 1)

# Shorten name to save typing
bdds <- bmx_d_demog_smp

# Create a new obesity variable
bdds <- bdds |> 
  mutate(obesity = if_else(bmxbmi >= 30, 1, 0)) |> 
  relocate(bmxbmi, obesity, .after = ridreth1)

# What percentage of people with obesity are in the activity monitor sample
bdds |> 
  group_by(obesity) |> 
  summarise(mean(in_sample))

# What percentage of males and females have activity monitor data available?
bdds |> 
  group_by(riagendr) |> 
  summarise(mean(in_sample))

# What is the maximum height in cm of a child under 16?
bdds |> 
  group_by(ridagemn > (16*12)) |> 
  summarise(max(bmxht, na.rm=TRUE))

# Write the new body measurement data to the derived data directory
bdds |> 
  write_csv("../../data/derived/body_measurements.csv")



