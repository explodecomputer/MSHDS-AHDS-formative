import glob
import re

# # Get the list of pid values from the filenames in data/original/accel/
accel_files = glob.glob("data/original/accel/accel-*.txt")
ACC_PID = [int(re.search(r"accel-(\d+).txt", f).group(1)) for f in accel_files]

# ACC_PID = [31128, 31129, 31131, 31132, 31133, 31134, 31137]

rule all:
    input:
        "data/derived/body_measurements.csv",
        "data/derived/sample.csv"


## Step 1: Checking the data files and making sure they are in a standard file format
# Check the body measures data:
rule check_bm_data:
    input:
        "data/original/BMX_D.csv"
    output:
        "logs/1-data-check-bm.log"
    shell:
        """
        cd code/1-data-prep
        bash 1-data-check-bm.sh > ../../logs/1-data-check-bm.log
        """

# Check the accelerometer data:
rule check_accel_data:
    input:
        expand("data/original/accel/accel-{pid}.txt", pid=ACC_PID)
    output:
        "logs/2-data-check-accel.log"
    shell:
        """
        cd code/1-data-prep
        bash 2-data-check-accel.sh > ../../logs/2-data-check-accel.log
        """
# Fix the accelerometer data:
rule fix_accel_data:
    input:
        "logs/2-data-check-accel.log",
        expand("data/original/accel/accel-{pid}.txt", pid=ACC_PID)
    output:
        expand("data/derived/accel/accel-{pid}.txt", pid=ACC_PID),
        "logs/3-data-fix-accel.log"
    shell:
        """
        cd code/1-data-prep
        bash 3-fix-accel-data.sh
        """

## Step 2: Generating a sample file

# Our sample file contains an binary variable that indicates whether a participant is in our sample versus not in our sample.
# A participant is included in our sample if they have accelerometer data and a BMI value.
# First we create a list of participant IDs for those with an accelerometer file:
rule make_pid_list:
    input:
        "logs/3-data-fix-accel.log",
        expand("data/derived/accel/accel-{pid}.txt", pid=ACC_PID)
    output:
        "data/derived/accel/pids-with-accel.txt"
    shell:
        """
        cd code/1-data-prep
        bash 4-list-accel-ids.sh
        """
# Then we derive a sample file:
rule make_sample:
    input:
        "data/derived/accel/pids-with-accel.txt",
        "data/original/BMX_D.csv"
    output:
        "data/derived/sample.csv"
    shell:
        """
        cd code/1-data-prep
        Rscript 5-generate-sample.R
        """


# Preparing and merging the demographics data

# Preparing and merging demographics variables into the body measurements data. 
# It also merges in the sample file prepared previously and saves the combined body_measurements.csv file to the derived data directory.
# Variable names are standardised to lower snake case.
rule merge_data:
    input:
        "data/original/BMX_D.csv",
        "data/original/DEMO_D.XPT",
        "data/derived/sample.csv"
    output:
        "data/derived/body_measurements.csv"
    shell:
        """
        cd code/5-data-prep
        Rscript demo_data_prep.R
        """
