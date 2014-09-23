## Quiz week 2

## packages
library(AppliedPredictiveModeling)
library(caret)
library(ggplot2)
library(Hmisc)
library(dplyr)

#=============#
## Question 1 #
#=============#
data(AlzheimerDisease)
head(predictors) ## the data
length(diagnosis) ## the response

## combining the data
adData <- data.frame(diagnosis, predictors)
trainIndex <- createDataPartition(diagnosis, p = 0.5, list = FALSE)
training <- adData[trainIndex, ]
testing <- adData[-trainIndex, ]

#=============#
## Question 2 #
#=============#
data(concrete)
set.seed(975)
inTrain <- createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training <- mixtures[inTrain, ]
testing <- mixtures[-inTrain, ]

head(training)
summary(training)
str(training)

featurePlot(x=mixtures, y=mixtures$CompressiveStrength, plot='pairs')

## plot CompressiveStrength (respons) versus the index of the samples
ggplot(data = training, aes(x=1:nrow(training), y=CompressiveStrength)) +
  geom_point()

## use cut2 function to split the numeric variables in groups
training$Cement_factor <- cut2(training$Cement, g = 4)
training$BlastFurnaceSlag_factor <- cut2(training$BlastFurnaceSlag, g = 4)
training$FlyAsh_factor <- cut2(training$FlyAsh, g = 4)
training$Water_factor <- cut2(training$Water, g = 4)
training$Superplasticizer_factor <- cut2(training$Superplasticizer, g = 4)
training$CoarseAggregate_factor <- cut2(training$CoarseAggregate, g = 4)
training$FineAggregate_factor <- cut2(training$FineAggregate, g = 4)
training$Age_factor <- cut2(training$Age, g = 4)

## plot CompressiveStrength (respons) versus the index of the samples color after the factor variables
ggplot(data = training, aes(x=1:nrow(training), y=CompressiveStrength, color=FlyAsh_factor)) +
  geom_point()

#=============#
## Question 3 #
#=============#
data(concrete)
set.seed(975)
inTrain <- createDataPartition(mixtures$CompressiveStrength, p = 3/4)[[1]]
training <- mixtures[inTrain, ]
testing <- mixtures[-inTrain, ]
head(training)
summary(training)

ggplot(data = training, aes(x=Superplasticizer)) +
  geom_histogram(binwidth=0.0002)

#=============#
## Question 4 #
#=============#
set.seed(3433)
data(AlzheimerDisease)
adData <- data.frame(diagnosis, predictors)
trainIndex <- createDataPartition(diagnosis, p = 3/4)[[1]]
training <- adData[trainIndex, ]
testing <- adData[-trainIndex, ]

head(training)

## select only variables that starts with IL
training2 <- select(training, starts_with('IL', ignore.case = FALSE))
head(training2)

## PCA
preProcess(training2, method = 'pca', thresh = 0.8)

#=============#
## Question 5 #
#=============#
set.seed(3433)
data(AlzheimerDisease)
adData <- data.frame(diagnosis, predictors)
trainIndex <- createDataPartition(diagnosis, p = 3/4)[[1]]
training <- adData[trainIndex, ]
testing <- adData[-trainIndex, ]
head(training)
str(training)
summary(training)

## new training and test sets
training2 <- select(training, starts_with('IL', ignore.case = FALSE))
training2 <- cbind(diagnosis = training$diagnosis, training2)
head(training2)

testing2 <- select(testing, starts_with('IL', ignore.case = FALSE))
testing2 <- cbind(diagnosis = testing$diagnosis, testing2)
head(testing2)

#================#
## non-PCA model #
#================#
non_PCA_model <- train(diagnosis ~ ., data = training2, method = 'glm')
non_PCA_model
## the model created
non_PCA_model$finalModel
pred <- predict(non_PCA_model, testing2)
confusionMatrix(pred, testing2$diagnosis) ## accuracy = 0.6463

#============#
## PCA model #
#============#
preProc <- preProcess(training2[, -1], method = 'pca', thresh = 0.8)
trainPCA <- predict(preProc, training2[, -1])
PCA_model <- train(training2$diagnosis ~ ., data = trainPCA, method = 'glm')

testPCA <- predict(preProc, testing2[, -1])
confusionMatrix(testing2$diagnosis, predict(PCA_model, testPCA)) ## accuracy = 0.7195

## end