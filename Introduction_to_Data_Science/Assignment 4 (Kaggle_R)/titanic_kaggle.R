
#=================================================================================================#
## Describe the competition problem

## The task is to predict if a given passenger survived the sinking of Titanic, the data have 
## information about gender and age of the passenger (allthoug not everybody have a registret age), 
## which class they travled, how much they paid for the ticket and other kind of information. I 
## will evaluate my model by accuracy (the propotion of passengers that I predict correctly).
#=================================================================================================#

## set working directory
setwd('C:\\Users\\Jakob\\Documents\\GitHub\\Introduction_to_Data_Science\\Assignment 4 (Peer assessment)')
setwd('C:\\Users\\jakschmi\\GitHub\\Data_Science_Class\\Assignment 4 (Peer assessment)')

## packages
library(Amelia)
library(plyr)
library(dplyr)
library(ggplot2)
library(vcd)
library(caret)

## load data
missing_types <- c('NA', '')
column_types <- c('integer', ## PassengerId
                  'factor', ## Survived
                  'factor', ## Pclass
                  'character', ## Name
                  'factor', ## Sex
                  'numeric', ## Age
                  'numeric', ## SibSp
                  'numeric', ## Parch
                  'character', ## Ticket
                  'numeric', ## Fare
                  'character', ## Cabin
                  'factor') ## Embarked

training <- read.csv(file = 'train.csv', header = TRUE, sep = ',', na.strings = missing_types,
                     colClasses = column_types)
testing <- read.csv(file = 'test.csv', header = TRUE, sep = ',', na.strings = missing_types,
                    colClasses = column_types[-2])

## training data summarys
head(training)
tail(training)
str(training)
summary(training)
nrow(training)

#=================================================================================================#
## Write a few sentences describing how you approached the problem.  What techniques did you use? 

## I start by doing a lot of visualization of the different variables individual but also in 
## combination with the Survived variable because this is what I will be predicting. I also look at 
## where there are missing values.
## I split the training set (from train.csv) into two separate sets so I can build a model on 2/3 of 
## the data and test my model on the remaining 1/3. I use the first 594 passengers to build my model 
## and the last 297 passengers to evaluate it.
## From the plot (show plot if possible) I conclude that a good baseline model will be a rule based 
## model that predict that women and children (Age =< 18) will survive and the rest die, and for the 
## passengers with missing Age value I predict after the Sex, women live and men die.
## I also try a random-forest model with the variables Age, Embarked, Fare, Parch, SibSp and Sex, 
## where the missing values will be replace with a "rough-fix", meaning that any missing value will 
## be replaced with the median if the variable is numeric or with the mode if the variable is 
## categorical.
#=================================================================================================#

#===================#
## Data exploration #
#===================#
## create data set with readable factor names
train_1.1 <- training
train_1.1$Survived <- revalue(train_1.1$Survived, c('0' = 'died', '1' = 'survived'))
train_1.1$Pclass <- revalue(train_1.1$Pclass, c('1' = 'first class', '2' = 'second class',
                                                '3' = 'third class'))
train_1.1$Embarked <- revalue(train_1.1$Embarked, c('S' = 'Southampton', 'C' = 'Cherbourg',
                                                    'Q' = 'Queenstown'))

## look at the missing values
missmap(train_1.1, legend = FALSE, col = c('yellow', 'black'), 
        main = 'Training data - Missingness Map')

## looking at the survival rate
ggplot(data = train_1.1, aes(x=Survived)) +
  geom_bar() +
  labs(title = 'Fate of passengers')

## passenger class distribution
ggplot(data = train_1.1, aes(x = Pclass)) +
  geom_bar() +
  labs(title = 'Number of passengers in each class')

## gender distribution
ggplot(data = train_1.1, aes(x = Sex)) +
  geom_bar() +
  labs(title = 'Number of men and women')

## age distribution
ggplot(data = train_1.1, aes(x = Age)) + 
  geom_histogram(binwidth = 1) +
  labs(title = 'Ages onboard')

## number of Siblings onboard (SibSp)
ggplot(data = train_1.1, aes(x = SibSp)) + 
  geom_histogram(binwidth = 1) +
  labs(title = 'Number of Siblings onboard')

## number of parents/Children onboard
ggplot(data = train_1.1, aes(x = Parch)) + 
  geom_histogram(binwidth = 1) +
  labs(title = 'Number of parents/Children onboard')

## fare prices
ggplot(data = train_1.1, aes(x = Fare)) + 
  geom_histogram(binwidth = 5) +
  labs(title = 'How much each passenger have paid to get onboard')

## embarked distination
ggplot(data = train_1.1, aes(x = Embarked)) + 
  geom_bar() +
  labs(title = 'Where each passenger boarded the ship')

## looking closer at the survival variable combined with other variables
## survival rate by sex
ggplot(data = train_1.1, aes(x=Sex, fill = Survived)) +
  geom_bar() +
  labs(title = 'Fate of passengers (in absolute numbers)')
ggplot(data = train_1.1, aes(x=Sex, fill = Survived)) +
  geom_bar(position = 'fill') +
  labs(title = 'Fate of passengers (as a propotion)')
mosaicplot(train_1.1$Sex ~ train_1.1$Survived, color = TRUE, xlab = 'Sex', ylab = 'Survived',
           main = 'Fate of passengers (mosaicplot)')

## survival rate by passenger class
ggplot(data = train_1.1, aes(x=Pclass, fill = Survived)) +
  geom_bar() +
  labs(title = 'Fate of passengers (in absolute numbers)')
ggplot(data = train_1.1, aes(x=Pclass, fill = Survived)) +
  geom_bar(position = 'fill') +
  labs(title = 'Fate of passengers (as a propotion)')
mosaicplot(train_1.1$Pclass ~ train_1.1$Survived, color = TRUE, xlab = 'Sex', ylab = 'Survived',
           main = 'Fate of passengers (mosaicplot)')

## survival rate by passenger age
ggplot(data = train_1.1, aes(x = Age, fill = Survived)) + 
  geom_histogram(binwidth = 1) +
  labs(title = 'Fate of passengers')

## survival rate by passenger age and sex
ggplot(data = train_1.1, aes(x = Age, fill = Survived)) + 
  geom_histogram(binwidth = 1) +
  facet_grid(Sex ~ .) +
  labs(title = 'Fate of passengers')

## survival rate by passenger age, sex and class
ggplot(data = train_1.1, aes(x = Age, fill = Survived)) + 
  geom_histogram(binwidth = 1) +
  facet_grid(Sex ~ Pclass) +
  labs(title = 'Fate of passengers')


#================================================================================================#
## Rule based model, women and childern (Age =< 18) survive and the rest dies, if Age is missing #
## women survive and men dies                                                                    #
#================================================================================================#

## split training data in two
train <- training[1:594, ]
test <- training[595:891, ]
head(train)

## women and children will survive model
train1 <- select(train, c(Survived, Sex, Age))
test1 <- select(test, c(Survived, Sex, Age))
head(test1)

women_child_survive_model <- function(obs) {
  pred <- c()
  for(i in 1:nrow(obs)) {
    temp <- obs[i, ]
    if(temp$Sex == 'female') {pred[i] <- 1}
    if(temp$Sex == 'male' & !is.na(temp$Age) & temp$Age <= 18) {pred[i] <- 1}
    if(temp$Sex == 'male' & is.na(temp$Age)) {pred[i] <- 0}
    if(temp$Sex == 'male' & !is.na(temp$Age) & temp$Age > 18) {pred[i] <- 0}
  }
  return(pred)
}

pred1 <- women_child_survive_model(test1)
length(pred1)

confusionMatrix(pred1, test1$Survived) ## 0.7441

## submit data
pred1_1 <- women_child_survive_model(testing)
length(pred1_1)
submit_data <- data.frame(PassengerId = testing$PassengerId,
                          Survived = pred1_1)
head(submit_data)
write.csv(submit_data, file = 'submit1.csv', quote = FALSE, row.names = FALSE)

## score of 0.7368 on Kaggle

#==================================================================================================#
## randomforest model
library(randomForest)
train2 <- select(train, -c(PassengerId, Name, Ticket, Cabin))
test2 <- select(test, -c(PassengerId, Name, Ticket, Cabin))
head(train2)

m1 <- randomForest(Survived ~ ., data = train2, na.action=na.roughfix)

test3 <- na.roughfix(test2)
pred2 <- predict(m1, test3[,-1])

confusionMatrix(pred2, test3$Survived) ## 0.8283


## submit data
training2 <- select(training, -c(PassengerId, Name, Ticket, Cabin))
head(training2)
m2 <- randomForest(Survived ~ ., data = training2, na.action=na.roughfix)

testing2 <- select(testing, -c(PassengerId, Name, Ticket, Cabin))
testing3 <- na.roughfix(testing2)
head(testing3)

pred2_1 <- predict(m2, testing3)

submit_data2 <- data.frame(PassengerId = testing$PassengerId,
                          Survived = pred2_1)
head(submit_data2)
write.csv(submit_data2, file = 'submit2.csv', quote = FALSE, row.names = FALSE)

## score of 0.7655 on Kaggle 

#==================================================================================================#
#===============================#
## improving the 'manuel' model #
#===============================#

temp1 <- select(training, -c(PassengerId, Name, Ticket, Cabin, SibSp, Parch, Embarked))
head(temp1)
temp2 <- filter(temp1, Sex == 'female', Pclass == 3)
nrow(temp2)
head(temp2, 15)

median(filter(temp2, Survived == 1)$Fare) ## 9.47
median(filter(temp2, Survived == 0)$Fare) ## 14.48

(9.47+14.48)/2

sur <- filter(temp2, Fare < 11.975)
nrow(filter(sur, Survived == 1))

live <- filter(temp2, Survived == 1)
nrow(live) ## 72

die <- filter(temp2, Survived == 0)
nrow(die) ## 72

str(training)

women_child_survive_model2 <- function(obs) {
  pred <- c()
  for(i in 1:nrow(obs)) {
    temp <- obs[i, ]
    if(temp$Pclass %in% c(1,2)) {
      if(temp$Sex == 'female') {pred[i] <- 1}
      if(temp$Sex == 'male' & !is.na(temp$Age) & temp$Age <= 18) {pred[i] <- 1}
      if(temp$Sex == 'male' & is.na(temp$Age)) {pred[i] <- 0}
      if(temp$Sex == 'male' & !is.na(temp$Age) & temp$Age > 18) {pred[i] <- 0}
    }
    if(temp$Pclass == 3) {
      if(temp$Sex == 'female' & temp$Fare < 11.975) {pred[i] <- 1}
      if(temp$Sex == 'female' & temp$Fare > 11.975) {pred[i] <- 0}
      if(temp$Sex == 'male') {pred[i] <- 0}  
    }
  }
  return(pred)
}

pred3 <- women_child_survive_model2(testing)
length(pred3)
submit_data3 <- data.frame(PassengerId = testing$PassengerId,
                          Survived = pred3)
head(submit_data3)
write.csv(submit_data3, file = 'submit3.csv', quote = FALSE, row.names = FALSE)

## score 0.7703 on Kaggle

## end