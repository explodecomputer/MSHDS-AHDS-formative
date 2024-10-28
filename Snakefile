import glob
import re

# # Get the list of pid values from the filenames in data/original/accel/
accel_files = glob.glob("data/original/accel/accel-*.txt")
ACC_PID = [int(re.search(r"accel-(\d+).txt", f).group(1)) for f in accel_files]

# To keep things a bit simpler, we can hard-code a small list of participant IDs instead of reading in every participant ID from the filenames as above
# This will mean that if any of the accelerometer data files change or some or added or removed then snakemake won't know to re-run the pipeline
# ACC_PID = [31128, 31129, 31131, 31132, 31133, 31134, 31137]

rule all:
    input:
        "data/derived/body_measurements.csv",
        "data/derived/sample.csv",
        "logs/1-data-check-bm.log",
        "logs/2-data-check-accel.log",
        "logs/3-data-fix-accel.log",
        "logs/4-list-accel-ids.log",
        "logs/5-generate-sample.log",
        "logs/6-demo-data-prep.log"


## Step 1: Checking the data files and making sure they are in a standard file format
# Check the body measures data:
rule check_bm_data:
    input:
        "data/original/BMX_D.csv"
    output:
        "logs/1-data-check-bm.log"
    shell:
        """
        cd code
        bash 1-data-check-bm.sh > ../logs/1-data-check-bm.log
        """

# Check the accelerometer data:
rule check_accel_data:
    input:
        "logs/1-data-check-bm.log",
        expand("data/original/accel/accel-{pid}.txt", pid=ACC_PID)
    output:
        "logs/2-data-check-accel.log"
    shell:
        """
        cd code
        bash 2-data-check-accel.sh > ../logs/2-data-check-accel.log
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
        cd code
        bash 3-data-fix-accel.sh > ../logs/3-data-fix-accel.log
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
        "data/derived/accel/pids-with-accel.txt",
        "logs/4-list-accel-ids.log"
    shell:
        """
        cd code
        bash 4-list-accel-ids.sh > ../logs/4-list-accel-ids.log
        """
# Then we derive a sample file:
rule make_sample:
    input:
        "logs/1-data-check-bm.log",
        "data/derived/accel/pids-with-accel.txt",
        "data/original/BMX_D.csv"
    output:
        "data/derived/sample.csv",
        "logs/5-generate-sample.log"
    shell:
        """
        cd code
        Rscript 5-generate-sample.R > ../logs/5-generate-sample.log
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
        "data/derived/body_measurements.csv",
        "logs/6-demo-data-prep.log"
    conda: "ahds_formative"
    shell:
        """
        cd code
        Rscript 6-demo-data-prep.R > ../logs/6-demo-data-prep.log
        """
