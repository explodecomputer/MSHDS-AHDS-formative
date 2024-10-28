#!/bin/bash 

## get all the IDs from the accelerometer files and store as a list in a file
ls ../../data/derived/accel | grep -Eo '[0-9]+' > ../../data/derived/accel/pids-with-accel.txt
