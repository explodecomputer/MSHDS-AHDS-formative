

datadir='../../data'

# read in the acceleromter ids and survey data
accelIds <- read.table(paste0(datadir, '/derived/accel/pids-with-accel.txt'), header=F, col.names='PID')
surveyData <- read.csv(paste0(datadir, '/original/BMX_D.csv'))

# merge together, keeping only participants with both types of data
dataComb <- merge(surveyData, accelIds, by.x='SEQN', by.y='PID', all.x=F, all.y=F)

# find all participant with a BMI value
ix <- which(!is.na(dataComb$BMXBMI))
dataComb$insample <- 0
dataComb$insample[ix] = 1

# see the numbers of people in our sample vs not in our sample
print(table(dataComb$insample))

# save a sample data file
write.csv(x = dataComb[,c('SEQN', 'insample')], file=paste0(datadir, '/derived/sample.csv'))

