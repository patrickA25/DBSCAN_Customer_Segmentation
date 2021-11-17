library(tidyverse)
library(cluster)
library(fpc)
library(dbscan)
library(ggpubr)
setwd("C:/Users/Patrick/Desktop/Final_project")

half_moon_example <- read_csv("half_moon_example.csv")


ggplot(half_moon_example,aes(y = Y, x = X)) + geom_point()
plot(half_moon_example)


k_means <- kmeans(half_moon_example,center=2)

half_moon_example$Cluster <- k_means$cluster
half_moon_example$Cluster <- as.factor(half_moon_example$Cluster)

kmean_graph <- ggplot(half_moon_example,aes(y = Y, x = X, col = Cluster)) + geom_point() +
annotate("point", x = k_means$centers[1,1], y = k_means$centers[1,2], size = 5.0) +
  annotate("point", x = k_means$centers[2,1], y = k_means$centers[2,2], size =5.0 ) + 
  ggtitle("K-means Clusting", subtitle = "K = 2")


half_moon_example_dbs <- read_csv("half_moon_example.csv")
test_dbs <- dbscan(half_moon_example_dbs, eps= 1.5, minPts = 2)

half_moon_example_dbs$Cluster <- as.factor(test_dbs$cluster)

Dens_graph <- ggplot(half_moon_example_dbs,aes (x = X , y = Y , col = Cluster)) + geom_point() +
  ggtitle("Density-Based Clustering", subtitle = "eps = 1.5 , MinPts = 2")

#Graph for slide desk deck and write up
ggarrange(kmean_graph,Dens_graph)