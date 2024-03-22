# Step 1: Download and unzip the dataset if not already downloaded
if (!file.exists("UCI HAR Dataset")) {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, destfile = "Dataset.zip", method = "curl")
        unzip("Dataset.zip")
}

# Step 2: Read the datasets into R
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("feature_id", "feature_name"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity_id", "activity_name"))

# Step 3: Merge the training and test datasets into one dataset
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

# Step 4: Extract only the measurements on the mean and standard deviation for each measurement
mean_std_features <- grep("mean\\(\\)|std\\(\\)", features$feature_name)
X_mean_std <- X[, mean_std_features]

# Step 5: Use descriptive activity names to name the activities in the data set
y$activity_name <- factor(activity_labels$activity_name[y$V1])

# Step 6: Label the data set with descriptive variable names
colnames(X_mean_std) <- features$feature_name[mean_std_features]

# Step 7: Create a tidy dataset with the average of each variable for each activity and each subject
library(dplyr)
tidy_data <- X_mean_std %>%
        mutate(activity = y$activity_name, subject = subject$V1) %>%
        group_by(activity, subject) %>%
        summarise_all(mean)

# Write the tidy dataset to a file
write.table(tidy_data, "tidy_dataset.txt", row.names = FALSE)
y$activity_name <- factor(activity_labels$activity_name[y$V1])
