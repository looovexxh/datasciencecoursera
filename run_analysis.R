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
selected_dataset<- whole_dataset[,grep("mean|std",data_colnames)]

### step 3 
whole_dataset_label<- rbind(testing_data_label,training_data_label)
activities_label <- as.factor(whole_dataset_label[,1])
levels(activities_label) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
whole_dataset_label[,1]<- activities_label

### step 4
colnames(whole_dataset_label) <- "Activity"
labeled_dataset<- cbind(selected_dataset,whole_dataset_label)

### step 5 
training_data_subject<- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt",header = FALSE)
testing_data_subject<- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt",header = FALSE)
whole_dataset_subject<-rbind(testing_data_subject,training_data_subject)
colnames(whole_dataset_subject) <- "Subject"
labeled_dataset<- cbind(labeled_dataset,whole_dataset_subject)

tidydata<- labeled_dataset %>%
  group_by(Subject,Activity) %>%
  summarize_all(mean)