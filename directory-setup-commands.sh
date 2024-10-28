###
### This script contains commands for setting up directories and moving data to the correct location


##
## making directories

mkdir -p data/original
mkdir -p data/derived
mkdir -p code
mkdir -p results
mkdir -p logs


##
## moving the data to the data directory

mv ~/Downloads/BMX_D.csv data/original
mv ~/Downloads/accel.zip data/original
mv ~/Downloads/DEMO_D.XPT data/original

# extract the acclerometer data from the zip file
unzip -d data/original data/original/accel.zip

# describe the data in a readme file
cd code

nano README.txt

