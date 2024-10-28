

datadir='../../data'

# read in the acceleromter ids and survey data
accelIds <- read.table(paste0(datadir, '/derived/accel/pids-with-accel.txt'), header=F, col.names='PID')
surveyData <- read.csv(paste0(datadir, '/original/BMX_D.csv'))

# add indicator to accel data frame to show participants have accel data
accelIds$hasAccel <- TRUE

# merge together, keeping all participants with either types of data
dataComb <- merge(surveyData, accelIds, by.x='SEQN', by.y='PID', all.x=T, all.y=T)

dim(accelIds)
dim(surveyData)
dim(dataComb)

# find all participant with a BMI value
ix <- which(!is.na(dataComb$BMXBMI) & !is.na(dataComb$hasAccel))
dataComb$insample <- 0
dataComb$insample[ix] <- 1

# see the numbers of people in our sample vs not in our sample
print(table(dataComb$insample))

# save a sample data file
write.csv(x = dataComb[,c('SEQN', 'insample')], file=paste0(datadir, '/derived/sample.csv'))

