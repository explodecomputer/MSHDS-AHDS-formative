#!/bin/bash 

DATADIR='../../data'

##
## Removing the first line of each file with format <ACTIGRAPH ID=PARTICIPANT_ID>

# remove first line in all accel files (with <.*> format)

echo -e "\n\nREMOVING FIRST LINE OF FORM  <ACTIGRAPH ID=PARTICIPANT_ID>\n"

mkdir ${DATADIR}/derived/accel
cp ${DATADIR}/original/accel/accel*.txt ${DATADIR}/derived/accel

# BSD sed (on mac OS) requires a value for -i flag
sed -i '' '1d' ${DATADIR}/derived/accel/accel*.txt

# on linux (GNU sed) use:
# sed -i '1d' ${DATADIR}/derived/accel/accel*.txt


## check that the first line of all accel files is the expected header

# header line with \t for tab and escaped double quotes
header="\"PAXSTAT\"\t\"PAXCAL\"\t\"PAXDAY\"\t\"PAXN\"\t\"PAXHOUR\"\t\"PAXMINUT\"\t\"PAXINTEN\"\t\"PAXSTEP\""

# count the number of files with this header line as line 1, shoud be the number of accel files
echo "Number of files with the correct header:"
head -n1 ${DATADIR}/derived/accel/accel*.txt | grep $header | wc -l



##
## Remove all the lines with 3 columns with NA values

echo -e "\n\nRemoving lines with NA\tNA\tNA\n"

# remove those lines
sed -i '' '/NA\tNA\tNA/d' ${DATADIR}/derived/accel/accel-*.txt

# check the files to make sure the lines have been removed correctly - rerun same command as above to find lines that don't have 8 columns
echo "Any lines still not with 8 columns are listed here:"
awk -F'\t' '(NF!=8){print $0}' ${DATADIR}/derived/accel/accel-*.txt | sort -u

