library(caret)
library(dplyr)
library(ggplot2)
library(lubridate)
library(randomForest)

setwd('C:\\Users\\Jakob\\Documents\\GitHub\\Practical_Machine_Learning\\Course Project')

missing_types <- c('NA', '#DIV/0!', '')
training <- read.csv(file = 'pml-training.csv', header = TRUE, na.strings = missing_types)
head(training)
ncol(training)

## remove predictors with more than 1000 NA's
training2 <- training[, colSums(is.na(training)) < (nrow(training)/2)]
head(training2)
str(training2)

## removing variables that is independent of the exercise (classe)
training3 <- training2[, -c(1:7)]
head(training3)

## splitting the data in a other test and training set
set.seed(159)
train_index <- createDataPartition(training3$classe, p = 0.7, list = FALSE)

train_data <- training3[train_index, ]
nrow(train_data)
test_data <- training3[-train_index, ]
nrow(test_data)

head(train_data)
head(test_data[-ncol(test_data)])

ggplot(data = train_data, aes(x = classe)) + 
  geom_bar()

## train a random forest model
# set.seed(159)
rfFit <- train(classe ~ ., data = train_data,
               method = 'rf',
               trControl = trainControl(method = 'cv', ## cross validation
                                        number = 4, ## 4 folds
                                        allowParallel = TRUE, 
                                        verboseIter = TRUE)
               )
tt <- now()

rfFit
ggplot(rfFit)
confusionMatrix(rfFit)

rfPred <- predict(rfFit, test_data[-ncol(test_data)])
head(rfPred, 20)

confusionMatrix(rfPred, test_data[, ncol(test_data)])

#==================================================================================================#
setwd('C:\\Users\\jakschmi\\GitHub\\Practical_Machine_Learning\\Course Project')

missing_types <- c('NA', '#DIV/0!', '')
testing <- read.csv(file = 'pml-testing.csv', header = TRUE, na.strings = missing_types)
head(testing)
ncol(testing)
summary(testing)

testing2 <- testing[, colSums(is.na(testing)) < 10]
head(testing2)
str(testing2)

## removing variables that is independent of the exercise (classe)
testing3 <- testing2[, -c(1:7)]
head(testing3)

testPred <- predict(rfFit, testing3[-ncol(testing3)])
head(testPred, 20)

## end