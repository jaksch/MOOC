
#==============#
## Quiz Week4A #
#==============#

## Q1
M1 <- matrix(c(1,2,3,4,5,
               2,3,2,5,3,
               5,5,5,3,2), nrow = 3, ncol = 5, byrow = TRUE, 
             dimnames = list(LETTERS[1:3], c('M','N','P','Q','R')))
M1

for(i in 1:dim(M1)[1]) {
  temp_mean <- mean(M1[i,])
  for(j in 1:dim(M1)[2]) {
    M1[i,j] <- M1[i,j] - temp_mean
  }
}
M1
for(i in 1:dim(M1)[2]) {
  temp_mean <- mean(M1[,i])
  for(j in 1:dim(M1)[1]) {
    M1[j,i] <- M1[j,i] - temp_mean
  }
}
M1

#==================#

## Q2
alpha <- 0
alpha <- 0.5
alpha <- 1
alpha <- 2

A <- c(1,0,1,0,1,alpha*2)
B <- c(1,1,0,0,1,alpha*6)
C	<- c(0,1,0,1,0,alpha*2)

simAB <- (A%*%B)/(sqrt(sum(A**2))*sqrt(sum(B**2)))
simAB

simAC <- (A%*%C)/(sqrt(sum(A**2))*sqrt(sum(C**2)))
simAC

simBC <- (B%*%C)/(sqrt(sum(B**2))*sqrt(sum(C**2)))
simBC

#=================================================================================================#

#==============#
## Quiz Week4B #
#==============#

## Q1
A <- c(2/7,3/7,6/7)

V1 <- c(-.286, .-.429, .857)
V2 <- c(-.857, .286, .429)
V3 <- c(.608, -.459, -.119)
V4 <- c(-.937, .312, .156)

A%*%V1
sqrt(V1%*%V1)

A%*%V2
sqrt(V2%*%V2)

A%*%V3
sqrt(V3%*%V3)

A%*%V4
sqrt(V4%*%V4)


#================#

## Q3
M1 <- matrix(c(1,1,
               2,2,
               3,4), nrow = 3, ncol = 2, byrow = TRUE, 
             dimnames = list(1:3, c('X','Y')))
M1

eigen(M1)


## Q4
A <- c(1,2,3)

V1 <- c(1, -2, 1)
V2 <- c(-3, -2, 5)
V3 <- c(-1, -2, 0)
V4 <- c(-4, 2, -1)

A%*%V1
A%*%V2
A%*%V3
A%*%V4

## end
