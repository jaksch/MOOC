
## Q1
library(ElemStatLearn)
library(caret)
library(dplyr)

data(vowel.train)
head(vowel.train)
vowel.train$y <- factor(vowel.train$y)

data(vowel.test)
head(vowel.test)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)
## random forest model
rfFit <- train(y ~ ., data = vowel.train, method = 'rf')
rfFit
rfPred <- predict(rfFit, vowel.test[, -1])
confusionMatrix(vowel.test$y, rfPred)

## boosted tree model
gbmFit <- train(y ~ ., data = vowel.train, method = 'gbm')
gbmFit
gbmPred <- predict(gbmFit, vowel.test[, -1])
confusionMatrix(vowel.test$y, gbmPred)

## agreement model
predDF <- data.frame(rfPred, gbmPred, y = vowel.test$y)
head(predDF)
agreeDF <- filter(predDF, rfPred == gbmPred)
head(agreeDF)
confusionMatrix(agreeDF$y, agreeDF[, 1])


## Q2
library(gbm)
set.seed(3433)
library(AppliedPredictiveModeling)
data(AlzheimerDisease)
adData <- data.frame(diagnosis,predictors)
inTrain <- createDataPartition(adData$diagnosis, p = 3/4)[[1]]
training <- adData[ inTrain,]
testing <- adData[-inTrain,]

set.seed(62433)
head(training)
str(training)
## random forest model
rfFit2 <- train(diagnosis ~ ., data = training, method = 'rf')
rfFit2
rfPred2 <- predict(rfFit2, testing[, -1])
confusionMatrix(testing$diagnosis, rfPred2)

## boosted tree model
gbmFit2 <- train(diagnosis ~ ., data = training, method = 'gbm')
gbmFit2
gbmPred2 <- predict(gbmFit2, testing[, -1])
confusionMatrix(testing$diagnosis, gbmPred2)

## linear discriminant model
ldaFit <- train(diagnosis ~ ., data = training, method = 'lda')
ldaFit
ldaPred <- predict(ldaFit, testing[, -1])
confusionMatrix(testing$diagnosis, ldaPred)

## ensamble model
predDF2 <- data.frame(rfPred2, gbmPred2, ldaPred, diagonsis = testing$diagnosis)
head(predDF2)

combModFit <- train(diagonsis ~ ., data = predDF2, method = 'rf')
combModFit
combModPred <- predict(combModFit, testing[, -1])
confusionMatrix(testing$diagnosis, combModPred)


## Q3
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain <- createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training <- concrete[ inTrain,]
testing <- concrete[-inTrain,]

head(training)
str(training)
set.seed(233)
# 
# lassoFit <- train(CompressiveStrength ~ ., data = training, method = 'glmnet',
#                   tuneLength = 15)

library(glmnet)
train.x <- as.matrix(training[, -9])
train.y <- training[, 9]
fit <- glmnet(x= train.x, y = train.y)
coef(fit)


## Q4
library(lubridate)
library(forecast)
dat <- read.csv("C:\\Users\\jakschmi\\GitHub\\Practical_Machine_Learning\\gaData.csv")
head(dat)
tail(dat)

training <- dat[year(dat$date) < 2012,]
head(training)
testing <- dat[(year(dat$date)) > 2011,]
head(testing)
tstrain <- ts(training$visitsTumblr)
head(tstrain)

plot(tstrain)
bats(tstrain)

fit <- bats(tstrain)
fcast <- forecast(fit, h=c(235))
attributes(fcast)
fcast
testing$visitsTumblr[1:10]
plot(fcast)
lines(testing$X, testing$visitsTumblr, col = "red")

1 - (sum(testing$visitsTumblr > fcast$upper[, 2])/length(testing$visitsTumblr))

## Q5
set.seed(3523)
library(AppliedPredictiveModeling)
data(concrete)
inTrain <- createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
training <- concrete[ inTrain,]
testing <- concrete[-inTrain,]

set.seed(325)
library(e1071)
svmFit <- svm(CompressiveStrength ~ ., data = training)
svmPred <- predict(svmFit, testing[, -9])
svmPred

library(hydroGOF)
rmse(svmPred, testing$CompressiveStrength)

## end