library(AppliedPredictiveModeling)
library(caret)
library(dplyr)

data(segmentationOriginal)
head(segmentationOriginal)

training <- filter(segmentationOriginal, Case == 'Train')
testing <- filter(segmentationOriginal, Case == 'Test')
nrow(training)
nrow(testing)
summary(training)

## Q1
set.seed(125)
cartFit <- train(Class ~ ., data = training, method = 'rpart')
cartFit
cartFit$finalModel
library(rpart.plot)
prp(cartFit$finalModel)

## Q3
library(pgmm)
data(olive)
head(olive)
olive <- olive[, -1]
str(olive)
summary(olive)

cartFit2 <- train(Area ~ ., data = olive, method = 'rpart')
cartFit2

newdata <- as.data.frame(t(colMeans(olive)))

predict(cartFit2, newdata)

## Q4
library(ElemStatLearn)
data(SAheart)
head(SAheart)
str(SAheart)
SAheart$chd <- factor(SAheart$chd)

set.seed(8484)
train <- sample(1:dim(SAheart)[1], size = dim(SAheart)[1]/2, replace=F)
trainSA <- SAheart[train, ]
testSA <- SAheart[-train, ]
head(trainSA)

set.seed(13234)
lrFit <- train(chd ~ age + alcohol + obesity + tobacco + typea + ldl, data = trainSA,
               method = 'glm')
lrFit
lrFit$results

pred_train <- predict(lrFit, trainSA[, -10])

pred_test <- predict(lrFit, testSA[, -10])

missClass <- function(values, prediction){sum(((prediction > 0.5)*1) != values) / length(values)}

missClass(trainSA[, 10], pred_train)
missClass(testSA[, 10], pred_test)

## Q5
data(vowel.train)
head(vowel.train)
vowel.train$y <- factor(vowel.train$y)

data(vowel.test)
head(vowel.test)
vowel.test$y <- factor(vowel.test$y)

set.seed(33833)
rfFit <- train(y ~ ., data = vowel.train,
               method = 'rf')
rfFit
varImp(rfFit)

## end