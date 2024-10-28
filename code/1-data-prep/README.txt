# Data file preparation


This folder contains the code to preprocess the data files and create a sample file.

## Step 1: Checking the data files and making sure they are in a standard file format

Check the body measures data:

bash 1-data-check-survey.sh	

Check the accelerometer data:

bash 2-data-check-accel.sh

Fix the accelerometer data:

bash 3-data-fix-accel.sh


## Step 2: Generating a sample file

Our sample file contains an binary variable that indicates whether a participant is in our sample versus not in our sample.

A participant is included in our sample if they have accelerometer data and a BMI value.

First we create a list of participant IDs for those with an accelerometer file:

bash 4-list-accel-ids.sh	

Then we derive a sample file:

Rscript 5-generate-sample.R
