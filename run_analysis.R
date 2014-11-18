#######Load in the tables from the txt files###

features <- read.table('./UCI_HAR_Dataset/features.txt')

X_test <- read.table('./UCI_HAR_Dataset/test/X_test.txt')

subject_test <- read.table('./UCI_HAR_Dataset/test/subject_test.txt')

y_test <- read.table('./UCI_HAR_Dataset/test/y_test.txt')

X_train <- read.table('./UCI_HAR_Dataset/train/X_train.txt')

subject_train <- read.table('./UCI_HAR_Dataset/train/subject_train.txt')

y_train <- read.table('./UCI_HAR_Dataset/train/y_train.txt')

activity_labels <- read.table('./UCI_HAR_Dataset/activity_labels.txt')
################################


######Step 1-Merge the training and test sets into one data frame.

X <- rbind(X_test, X_train)
#save(X, file="X.Rda")
#load("X.Rda")

y <- rbind(y_test, y_train)
#save(y, file="y.Rda")
#load("y.Rda")

subject <- rbind(subject_test, subject_train)
#save(subject, file="subject.Rda")
#load("subject.Rda")

##Add y and subject
X <- cbind(X, y)
X <- cbind(X, subject)
######End Step 1##################

######Step 2-Get the mean and standard deviations measurements out of the data set.

##Get a list of names from the 2 column feature data frame
features <- features[[2]]
colnames(X) <- features[1:561]

##Change y and subject column names to something little more descriptive.
colnames(X)[562:563] <- c('Activity', 'Subject_ID')

##Get two factor vectors of the variables with standard deviation and mean in their names.
features_mean <- features[grepl("*mean\\(\\)*",features)]
features_std <- features[grepl("*std\\(\\)*", features)]

##Combine the factor vectors.
filtered_features <- c(as.character(features_mean), as.character(features_std))
filtered_features <- c(filtered_features, "Activity", "Subject_ID")

##Use the factor vector to select just the variables with std and mean in their names.
X <- X[, filtered_features]
#######End Step 2##############


######Step 3-Label the activity names descriptively, according the labels given in the activity labels file.

##Map the Activity values
X$Activity <- factor(X$Activity, labels = activity_labels[,2])
######End Step 3##############


######Step 5-Create a second data set with the average of each variable for each excercise and each subject.

second_set <- aggregate(X[1:66], list(Subject=X$Subject, Activity=X$Activity), mean)
write.table(second_set, "./second_set.txt", row.name=FALSE)
######End Step 5#############
