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

mv ~/Downloads/BMX_D.csv data/
mv ~/Downloads/accel.zip data/

# extract the acclerometer data from the zip file
unzip -d data/ data/accel.zip

# describe the data in a readme file
cd code

nano README.txt

