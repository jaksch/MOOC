library(ggplot2)
library(dplyr)

## Quiz Week5B (Basic) MMDS 


## Q1

p1 <- c(23,40)
p2 <- c(29,97)
p3 <- c(25,125)
p4 <- c(28,145)
p5 <- c(33,22)
p6 <- c(35,63)
p7 <- c(38,115)
p8 <- c(42,57)
p9 <- c(43,83)
p10 <- c(44,105)
p11 <- c(55,20)
p12 <- c(50,30)
p13 <- c(50,60)
p14 <- c(55,63)
p15 <- c(50,90)
p16 <- c(55,118)
p17 <- c(50,130)
p18 <- c(64,37)
p19 <- c(63,88)
p20 <- c(65,140)

data <- data.frame(point = 1:20,
                   x = c(p1[1],p2[1],p3[1],p4[1],p5[1],p6[1],p7[1],p8[1],p9[1],p10[1],p11[1],p12[1],
                         p13[1],p14[1],p15[1],p16[1],p17[1],p18[1],p19[1],p20[1]),
                   y = c(p1[2],p2[2],p3[2],p4[2],p5[2],p6[2],p7[2],p8[2],p9[2],p10[2],p11[2],p12[2],
                         p13[2],p14[2],p15[2],p16[2],p17[2],p18[2],p19[2],p20[2]),
                   init_cent = c(1,1,1,0,1,1,0,1,0,1,1,0,0,1,0,0,0,1,0,0),
                   cluster = c(1,2,3,0,4,5,0,6,0,7,8,0,0,9,0,0,0,10,0,0))
data

ggplot(data = data, aes(x=x, y=y, size = init_cent)) +
  geom_point()

data2 <- filter(data, cluster == 0)
data3 <- filter(data, cluster != 0)

for(i in 1:nrow(data2)) {
  temp <- data2[i,]
  dist <- 10000
  for(j in 1:nrow(data3)) {
    temp2 <- data3[j,]
    dist_new <- sqrt((temp$x - temp2$x)^2 + (temp$y - temp2$y)^2)
    if(dist_new < dist) {
      data2$cluster[i] <- temp2$cluster
      dist <- dist_new
    }
  }
}

data4 <- rbind(data2, data3)
data4 %>%
  group_by(cluster) %>%
  summarise(new_centroid_X = mean(x),
            new_centroid_y = mean(y))

data4$cluster <- factor(data4$cluster)
ggplot(data = data4, aes(x=x, y=y, color = cluster)) +
  geom_point()

#=================================================================================================#

## Q2
c1 <- c(5,10)
c2 <- c(20,5)

y_all <- list(c(7,12,12,8), c(7,8,12,5), c(6,7,11,4), c(6,15,13,7))
b_all <- list(c(16,16,18,5), c(15,14,20,10), c(11,5,17,2), c(16,16,18,5))

for(i in 1:4) {
  y <- y_all[[i]]
  b <- b_all[[i]]
  
  y_UL <- c(y[1],y[2])
  y_UR <- c(y[3],y[2])
  y_LL <- c(y[1],y[4])
  y_LR <- c(y[3],y[4])
  
  b_UL <- c(b[1],b[2])
  b_UR <- c(b[3],b[2])
  b_LL <- c(b[1],b[4])
  b_LR <- c(b[3],b[4])
  
  data <- data.frame(point = 1:10,
                     x = c(c1[1],c2[1],y_UL[1],y_UR[1],y_LL[1],y_LR[1],b_UL[1],b_UR[1],b_LL[1],b_LR[1]),
                     y = c(c1[2],c2[2],y_UL[2],y_UR[2],y_LL[2],y_LR[2],b_UL[2],b_UR[2],b_LL[2],b_LR[2]),
                     centroid = c("y","b","y","y","y","y","b","b","b","b"))
  
  p <- ggplot(data, aes(x=x, y=y, shape = centroid)) + 
    geom_point() +
    labs(title = paste('option', i))
  print(p)
  
  
  data2 <- data[1:2,]
  data3 <- data[3:10,]
  data3$centroid_new <- rep('o', 8)
  for(j in 1:nrow(data3)) {
    temp <- data3[j,]
    
    dist_y <- sqrt((temp$x - data2$x[1])^2 + (temp$y - data2$y[1])^2)
    dist_b <- sqrt((temp$x - data2$x[2])^2 + (temp$y - data2$y[2])^2)
    
    if(dist_y > dist_b) {data3$centroid_new[j] <- 'b'}
    if(dist_y < dist_b) {data3$centroid_new[j] <- 'y'}
  }
  print(i)
  print(data3)
  
}

#=================================================================================================#

## Q3 + Q4 + Q5 by hand



