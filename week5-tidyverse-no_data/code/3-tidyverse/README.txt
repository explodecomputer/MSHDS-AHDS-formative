# Preparing and merging the demographics data

This directory contains code for preparing and merging demographics variables into the body measurements data. It also merges in the sample file prepared previously and saves the combined body_measurements.csv file to the derived data directory. Variable names are standardised to lower snake case.

conda activate ahds_formative
Rscript demo_data_prep.R
