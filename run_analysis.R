
#add necessary packages
require("data.table") 
require("reshape2") 


# load the activity labels from the text file
activ_lbl <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# load the data column lables from the text file 
features <- read.table("./UCI HAR Dataset/features.txt")[,2] 

# extract the mean and standard dev for each measurement. 
features_extract <- grepl("mean|std", features) 


# load and process the X_test & y_test data files
X_TEST <- read.table("./UCI HAR Dataset/test/X_test.txt") 

Y_TEST <- read.table("./UCI HAR Dataset/test/y_test.txt") 

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") 

names(X_TEST) = features

# extract only the measurements on the mean and standard deviation for each measurement. 
X_TEST = X_TEST[,features_extract] 

# load the activity labels 
Y_TEST[,2] = activ_lbl[Y_TEST[,1]] 

names(Y_TEST) = c("Activity_ID", "Activity_Label") 

names(subject_test) = "subject" 

# bind the data 
TEST_DATA <- cbind(as.data.table(subject_test), Y_TEST, X_TEST)

# load and process X_train & y_train data files 
X_TRAIN <- read.table("./UCI HAR Dataset/train/X_train.txt") 

Y_TRAIN <- read.table("./UCI HAR Dataset/train/y_train.txt") 
 
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
 
names(X_TRAIN) = features 


# extract only the measurements on the mean and standard deviation for each measurement 
X_TRAIN = X_TRAIN[,features_extract] 

# load activity data files
Y_TRAIN[,2] = activ_lbl[Y_TRAIN[,1]] 

names(Y_TRAIN) = c("Activity_ID", "Activity_Label") 

names(subject_train) = "subject" 


# bind the data 
TRAIN_data <- cbind(as.data.table(subject_train), Y_TRAIN, X_TRAIN) 

# merge test and train data together
data = rbind(TEST_DATA, TRAIN_data) 

ID_labels   = c("subject", "Activity_ID", "Activity_Label") 

DATA_labels = setdiff(colnames(data), ID_labels) 

MELT_data      = melt(data, id = ID_labels, measure.vars = DATA_labels) 

# apply mean function to dataset
TIDY_data   = dcast(MELT_data, subject + Activity_Label ~ variable, mean) 

# write the table to a text file
write.table(TIDY_data, file = "./tidy_data.txt") 

