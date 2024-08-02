###
### This script contains commands for setting up directories and moving data to the correct location


##
## making directories

mkdir -d data/original
mkdir data/derived

mkdir code

mkdir results


##
## moving the data to the data directory

mv ~/Downloads/BMX_D.csv data/
mv ~/Downloads/accel.ZIP data/

# extract the acclerometer data from the zip file
unzip -d data/ data/accel.ZIP

# describe the data in a readme file
cd code

nano README.txt

