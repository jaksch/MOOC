setwd('C:\\Users\\jakschmi\\GitHub\\Data_Science_Class\\Assignment 5 (MachineLearning_R)')

library(caret)
library(ggplot2)

data <- read.csv(file = 'seaflow_21min.csv', header = TRUE)
head(data)
nrow(data)

## summary Q1 + Q2
summary(data)

index <- createDataPartition(data$pop, list = FALSE)

training <- data[index, ]
testing <- data[-index, ]

head(training)
nrow(training)
head(testing)
nrow(testing)

## mean Q3
mean(training$time)
mean(testing$time)

## plot Q4
ggplot(data = training, aes(x = pe, y = chl_small, color = pop)) +
  geom_point()

## decision tree Q5, Q6 and Q7
library(rpart)
model <- rpart(pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small, method = 'class',
               data = training)
model

ggplot(data = training, aes(x = pe, y = chl_small, color = pop)) +
  geom_point() +
  geom_vline(aes(xintercept = 5004))

## predict on the test set Q8
head(testing)
pred <- predict(model, testing[,-12])
head(pred)

for(i in 1:nrow(pred)){
  pred[i,] <- max(pred[i,]) == pred[i,]
}

library(reshape2)
library(dplyr)
temp <- melt(pred)
temp2 <- filter(temp, value == 1)
head(temp2)
temp3 <- arrange(temp2, Var1)
head(temp3)

confusionMatrix(temp3$Var2, testing$pop)

## random forest Q9 + Q10
library(randomForest)
model2 <- randomForest(pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small,
                       data = training)
model2

pred2 <- predict(model2, testing[, -12])
head(pred2)

confusionMatrix(pred2, testing$pop)

importance(model2)

## support vector machine Q11 + Q12
library(e1071)
model3 <- svm(pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small, data = training)
model3

pred3 <- predict(model3, testing[, -12])
head(pred3)

confusionMatrix(pred3, testing$pop)

## sanity chech the data Q13 + Q14
str(data)
plot(data$fsc_big, data$pop)

head(data)
training2 <- filter(training, file_id != 208)
nrow(training)
nrow(training2)

model4 <- svm(pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small, data = training2)
model4

testing2 <- filter(testing, file_id != 208)
pred4 <- predict(model4, testing2[, -12])
head(pred4)

confusionMatrix(pred4, testing2$pop)

0.9709 - 0.9181

## end