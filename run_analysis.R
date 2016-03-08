library(reshape2)

filename <- "getdata_dataset.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileURL, filename, method="curl")

unzip(filename)

path_rf <- file.path("." , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
setwd(path_rf)

activitylabels <- read.table("activity_labels.txt")
features <- read.table("features.txt",header = F)
activitylabels <- activitylabels[,2]
features <- features[,2]

subtrain <- read.table("train/subject_train.txt")
subtrainx <- read.table("train/X_train.txt")
subtrainy <- read.table("train/Y_train.txt")

subtest <- read.table("test/subject_test.txt")
subtestx <- read.table("test/X_test.txt")
subtesty <- read.table("test/Y_test.txt")

sub <- rbind(subtrain,subtest)
x <- rbind(subtrainx,subtestx)
y <- rbind(subtrainy,subtesty)

names(sub)<-c("subject")
names(y)<- c("activity")
names(x)<- features

datatotal <- cbind(y,sub,x)

subdataf<-features[grep("mean\\(\\)|std\\(\\)", features)]
selectedname<-c( "subject", "activity",as.character(subdataf) )
datatotal<-subset(datatotal,select=selectedname)

for (j in 1:length(activitylabels)){
        datatotal$activity[datatotal$activity==j]=as.character(activitylabels[j])
}

names(datatotal)<-gsub("^t", "time", names(datatotal))
names(datatotal)<-gsub("^f", "frequency", names(datatotal))
names(datatotal)<-gsub("Acc", "Accelerometer", names(datatotal))
names(datatotal)<-gsub("Gyro", "Gyroscope", names(datatotal))
names(datatotal)<-gsub("Mag", "Magnitude", names(datatotal))
names(datatotal)<-gsub("BodyBody", "Body", names(datatotal))

library(plyr)
datout <- aggregate(. ~subject + activity, datatotal, mean)
datout<-datout[order(datout$subject,datout$activity),]
write.table(datout, file = "tidydata.txt",row.name=FALSE)

getwd()

