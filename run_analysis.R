library(readr)
library(dplyr)
library(tidyr)
### step 1
## get the training data
training_data<- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",header = FALSE)
training_data_label <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt",header = FALSE)
data_colnames <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt",header = FALSE)
data_colnames<- data_colnames[,2]
colnames(training_data)<- data_colnames

## get the testing data
testing_data<- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",header = FALSE)
testing_data_label <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt",header = FALSE)
colnames(testing_data)<- data_colnames

## merge the table
whole_dataset<- rbind(testing_data,training_data)

### step 2
selected_dataset<- whole_dataset[,grep("mean|std|Mean|Std",data_colnames)]

### step 3 
whole_dataset_label<- rbind(testing_data_label,training_data_label)
activities_label <- as.factor(whole_dataset_label[,1])
levels(activities_label) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
whole_dataset_label[,1]<- activities_label

### step 4
colnames(whole_dataset_label) <- "Activity"
labeled_dataset<- cbind(selected_dataset,whole_dataset_label)

names(labeled_dataset)<-gsub("Acc", "Accelerometer", names(labeled_dataset))
names(labeled_dataset)<-gsub("Gyro", "Gyroscope", names(labeled_dataset))
names(labeled_dataset)<-gsub("BodyBody", "Body", names(labeled_dataset))
names(labeled_dataset)<-gsub("Mag", "Magnitude", names(labeled_dataset))
names(labeled_dataset)<-gsub("^t", "Time", names(labeled_dataset))
names(labeled_dataset)<-gsub("^f", "Frequency", names(labeled_dataset))
names(labeled_dataset)<-gsub("tBody", "TimeBody", names(labeled_dataset))
names(labeled_dataset)<-gsub("-mean()", "Mean", names(labeled_dataset), ignore.case = TRUE)
names(labeled_dataset)<-gsub("-std()", "STD", names(labeled_dataset), ignore.case = TRUE)
names(labeled_dataset)<-gsub("-freq()", "Frequency", names(labeled_dataset), ignore.case = TRUE)
names(labeled_dataset)<-gsub("angle", "Angle", names(labeled_dataset))
names(labeled_dataset)<-gsub("gravity", "Gravity", names(labeled_dataset))



### step 5 
training_data_subject<- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt",header = FALSE)
testing_data_subject<- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt",header = FALSE)
whole_dataset_subject<-rbind(testing_data_subject,training_data_subject)
colnames(whole_dataset_subject) <- "Subject"
labeled_dataset<- cbind(labeled_dataset,whole_dataset_subject)

tidydata<- labeled_dataset %>%
  group_by(Subject,Activity) %>%
  summarise_all(funs(mean))

### write table
write.table(tidydata,file = "tidydataset.txt",row.name=FALSE)
