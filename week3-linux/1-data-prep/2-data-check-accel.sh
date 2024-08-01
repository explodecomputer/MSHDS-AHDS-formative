#!/bin/bash 

DATADIR='../../data'

##
## checking the accelerometer data

# pick one example and check the top

# list some files
ls ${DATADIR}/original/accel/ | head

head ${DATADIR}/original/accel/accel-31128.txt

# print top of example accel file
awk -F'\t' '{print NF}' ${DATADIR}/original/accel/accel-31128.txt | head



#### check that all lines in all the accel files (except first) have 8 columns and fix those that don't

# check that all lines have 8 columns
cat ${DATADIR}/derived/accel/accel-*.txt | grep -v '<' | awk -F'\t' '{print NF}' | grep -v 8 | sort -u

# print all lines that don't have 8 columns
cat ${DATADIR}/derived/accel/accel-*.txt | grep -v '<' | awk -F'\t' '(NF!=8){print $0}' | sort -u

# see which files the NA lines exist in
grep -vH '<' ${DATADIR}/derived/accel/accel-*.txt | grep "NA\tNA\tNA" | sort -u

#awk -F'\t' '(NF!=8){print $0}' ${DATADIR}/derived/accel/accel-*.txt | sort -u

