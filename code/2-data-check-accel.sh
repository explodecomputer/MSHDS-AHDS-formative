#!/bin/bash 

DATADIR='../../data'

##
## checking the accelerometer data

# number of accelerometer files
numFiles=`ls ${DATADIR}/original/accel | wc -l`
echo "Number of accelerometer files: $numFiles" 


# pick one example and check the top

# list some files
echo "Some file names:"
ls ${DATADIR}/original/accel | head

# look at the top of an example file
echo "Top of example file:"
head ${DATADIR}/original/accel/accel-31128.txt

# print top of example accel file
echo "Number of fields for top of example file:"
awk -F'\t' '{print NF}' ${DATADIR}/original/accel/accel-31128.txt | head



#### check that all lines in all the accel files (except first) have 8 columns

# check that all lines have 8 columns
echo "Number of columns found in the accelerometer files, different from 8:"
cat ${DATADIR}/original/accel/accel-*.txt | grep -v '<' | awk -F'\t' '{print NF}' | grep -v 8 | sort -u

# print all lines that don't have 8 columns
echo "Lines that don't have 8 columns:"
cat ${DATADIR}/original/accel/accel-*.txt | grep -v '<' | awk -F'\t' '(NF!=8){print $0}' | sort -u

# see which files the NA lines exist in
echo "Files containing NA lines:"
grep -vH '<' ${DATADIR}/original/accel/accel-*.txt | grep "NA\tNA\tNA" | sort -u

