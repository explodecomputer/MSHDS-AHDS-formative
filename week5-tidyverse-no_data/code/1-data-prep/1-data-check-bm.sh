#!/bin/bash

DATADIR='../../data'

echo -e "\n Top of body measures data file:"
head ${DATADIR}/original/BMX_D.csv


##
## checking the body measures file


# the number of lines in the file
wc -l ${DATADIR}/original/BMX_D.csv


# find the number of fields at the top of the file

echo -e "\n\nNumber of fields on first 10 lines:"
awk -F, '{print NF}' ${DATADIR}/original/BMX_D.csv | head


# check the same number of fields all the way down the file

echo -e "\n\nPrint any lines that do not have 28 fields:"
awk -F, '{print NF}' ${DATADIR}/original/BMX_D.csv | grep -v 28

echo -e "\n\n"
