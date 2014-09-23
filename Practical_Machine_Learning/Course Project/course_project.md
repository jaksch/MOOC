# Practical Machine Learning Course Project
Jakob Schmidt  
Saturday, August 23, 2014  

Background of the data
---

Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E).

Class A corresponds to the specified execution of the exercise, while the other 4 classes correspond to common mistakes. Participants were supervised by an experienced weight lifter to make sure the execution complied to the manner they were supposed to simulate. The exercises were performed by six male participants aged between 20-28 years, with little weight lifting experience. We made sure that all participants could easily simulate the mistakes in a safe and controlled manner by using a relatively light dumbbell (1.25kg). See more [here](http://groupware.les.inf.puc-rio.br/har#weight_lifting_exercises).

The goal of this project is to predict the manner in which they did the exercise.

Data Analysis
---



First I load the training and testing data.


```r
missing_types <- c('NA', '#DIV/0!', '')
training <- read.csv(file = 'pml-training.csv', header = TRUE, na.strings = missing_types)
testing <- read.csv(file = 'pml-testing.csv', header = TRUE, na.strings = missing_types)
```

There is a lot of variables that mainly consists of missing values so I remove those. The first 
seven variables is meta-data information, that is not relevant to use in the prediction, so I will 
remove those as well.



```r
training2 <- training[, colSums(is.na(training)) < (nrow(training)/2)]
training3 <- training2[, -c(1:7)]
```


Now I have the data that I want to fit a prediction model on, I split the data 70/30 into an another training set that I will used to fit my model and a test set I will use to evaluate the model on. I do it using the `createDataPartition()` function from the caret packages because it does stratified sampling on the response variable out off the box.


```r
train_index <- createDataPartition(training3$classe, p = 0.7, list = FALSE)
train_data <- training3[train_index, ]
test_data <- training3[-train_index, ]
```

Now I have the data that I want to fit a model on. I fit a random forest to the `train_data` using cross validation and evaluate the model performance on the `test_data`.

Fitting the model:

```r
rfFit <- train(classe ~ ., data = train_data,
               method = 'rf',
               trControl = trainControl(method = 'cv', ## cross validation
                                        number = 4, ## 4 folds
                                        allowParallel = TRUE)
               )
```

The in-sample error determined from cross validation.

```r
confusionMatrix(rfFit)
```

```
## Cross-Validated (4 fold) Confusion Matrix 
## 
## (entries are percentages of table totals)
##  
##           Reference
## Prediction    A    B    C    D    E
##          A 28.4  0.2  0.0  0.0  0.0
##          B  0.0 19.0  0.1  0.0  0.0
##          C  0.0  0.1 17.3  0.3  0.0
##          D  0.0  0.0  0.1 16.1  0.1
##          E  0.0  0.0  0.0  0.0 18.3
```

This looks very promising, lets see how accurate the model predicts cases it have not been trained on. I now use the trained model to predict on the `test_data` data set.


```r
rfPred <- predict(rfFit, test_data[-ncol(test_data)])
confusionMatrix(rfPred, test_data[, ncol(test_data)])
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1674    9    0    0    0
##          B    0 1128    5    0    1
##          C    0    1 1018    8    3
##          D    0    1    3  955    3
##          E    0    0    0    1 1075
## 
## Overall Statistics
##                                         
##                Accuracy : 0.994         
##                  95% CI : (0.992, 0.996)
##     No Information Rate : 0.284         
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.992         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity             1.000    0.990    0.992    0.991    0.994
## Specificity             0.998    0.999    0.998    0.999    1.000
## Pos Pred Value          0.995    0.995    0.988    0.993    0.999
## Neg Pred Value          1.000    0.998    0.998    0.998    0.999
## Prevalence              0.284    0.194    0.174    0.164    0.184
## Detection Rate          0.284    0.192    0.173    0.162    0.183
## Detection Prevalence    0.286    0.193    0.175    0.163    0.183
## Balanced Accuracy       0.999    0.995    0.995    0.995    0.997
```

A random forest seems to be a good model choice, it have very high accuracy and it seems to be generalizing very well. 

Conclusion
---

From the high accuracy from both the `train_data` and `test_data` set I expect the trained model to give a very low out of sample error, assuming that the training and testing data sets are from the same population. 

