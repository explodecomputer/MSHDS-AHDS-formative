###
### This script contains commands for setting up directories and moving data to the correct location


##
## making directories

mkdir -p data/original
mkdir data/derived

mkdir code

mkdir results


##
## moving the data to the data directory

mv ~/Downloads/BMX_D.csv data/original
mv ~/Downloads/accel.zip data/original

# extract the acclerometer data from the zip file
unzip -d data/original data/accel.zip

# describe the data in a readme file
cd code

nano README.txt

