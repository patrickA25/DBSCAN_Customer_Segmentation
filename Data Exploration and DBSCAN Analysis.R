library(tidyverse)
library(lubridate)
library(PerformanceAnalytics)
library(cluster)
library(plotly)
library(dbscan)


marketing_data <- read.delim("marketing_campaign.csv", sep = "\t")
str(marketing_data)

#summary Stats for Education
table(marketing_data$Education)
#summary stats for Kids in home
table(marketing_data$Kidhome)
#summary stats for Teens in home
table(marketing_data$Teenhome)

#for income the following things need to be removed
#drop the NA from the data set
#the remove outlie from the data set. just one data point
summary(marketing_data$Income)
ggplot(marketing_data, aes ( y = Income)) + geom_boxplot()

#For marital Status the following adjustments will be made:
#move alone to singel
#remove the Absurd and YOLO values
table(marketing_data$Marital_Status)

#DT_customer will be converted to Date datatype.
marketing_data$Dt_Customer <-  dmy(marketing_data$Dt_Customer)
summary(marketing_data$Dt_Customer)

#Summary stats for Recency
summary(marketing_data$Recency)

#Summary stats for amount of wine baught
summary(marketing_data$MntWines)
ggplot(marketing_data, aes(y = MntWines)) + geom_boxplot()

#Summary stats for number of deals with purchases
summary(marketing_data$NumDealsPurchases)
ggplot(marketing_data, aes(y = NumDealsPurchases)) + geom_boxplot()

#Summary stats for number of purchases made in store
summary(marketing_data$NumStorePurchases)
ggplot(marketing_data, aes(y = NumStorePurchases)) + geom_boxplot()

#Summary stats of the number of people that complained
table(marketing_data$Complain)

#Data cleaning and manipulation
  #[X] Drop the NA for the income data
  #[X] Convert Dt_date into a date data type
  #[X] remove the YOLO and Absurd from Marital Status
  #[X] move Alone to singel
  #[X] Convert education to a numeric datatype.
  #[X] remove person with income of 666,666 

marketing_data <-  marketing_data %>% filter(!(is.na(Income))) %>%
  filter(Income != 666666) %>%
  filter(Marital_Status != "YOLO") %>%
  filter(Marital_Status != 'Absurd') %>% 
  mutate(Education_num = if_else(Education == 'Basic' ,1,
                                 if_else(Education == 'Graduation',2,
                                         if_else(Education == '2n Cycle', 3,
                                                 if_else(Education == 'Master' , 4,
                                                         if_else(Education == 'PhD',5,-1)))))) %>%
  mutate(Marital_status_num = if_else(Marital_Status == 'Alone',1,
                                      if_else(Marital_Status == 'Single',1,
                                              if_else(Marital_Status == 'Divorced',2,
                                                      if_else(Marital_Status == 'Married',3,
                                                              if_else(Marital_Status == 'Together',4,
                                                                      if_else(Marital_Status == 'Widow',5,-1))))))) %>%
  mutate(Person_age = 2021 - Year_Birth ) %>% 
  filter(Person_age < 100)





#Data set that will be used for clustering
clustering_data <- marketing_data_slim %>%
                   select(MntMeatProducts,MntFruits,MntGoldProds)


#Plotting clustering data to get a better undstanding.
ggplot(clustering_data, aes(x = (MntMeatProducts), y = (MntGoldProds))) + geom_point()
ggplot(clustering_data, aes(x = (MntMeatProducts), y = (MntFruits))) + geom_point()



#Adjusting the scale of the data by taking the forth root
clustering_data$MntMeatProducts <- clustering_data$MntMeatProducts^.25 
clustering_data$MntFruits <- clustering_data$MntFruits^.25
clustering_data$MntGoldProds <- clustering_data$MntGoldProds^.25


#Finding the value for eps, and minpts
kNNdistplot(clustering_data, k = 3)
abline(h = .4)

#Running the DBSCAN on the clustering data
clust_data <- dbscan(clustering_data,minPts = 3,eps = .4)
clust_data$cluster

#Adding the DBSCAN cluster back to the data.
clustering_data$clust <- clust_data$cluster

#Running k-means clustering on dataset with centers set to 3
k_mean <- kmeans(clustering_data[,1:3], centers = 3)

#Adding the k-means clusters back to the dataset.
clustering_data$kmean_clust <- k_mean$cluster


#Bulding 3D plot of the K-menas cluster data
plot_ly(x = (clustering_data$MntMeatProducts), 
        y = (clustering_data$MntFruits), 
        z = (clustering_data$MntGoldProds)) %>% 
  add_markers(color = factor(clustering_data$kmean_clust)) %>%
  layout(scene = list(xaxis = list(title = "Meat Products"),
                      yaxis = list(title = "Fruit Products"),
                      zaxis = list(title = "Gold Products")),
         paper_bgcolor = 'rgb(243,243,243)')

#Building 3D plot of the DBSCAN cluster data
plot_ly(x = (clustering_data$MntMeatProducts), 
        y = (clustering_data$MntFruits), 
        z = (clustering_data$MntGoldProds)) %>% 
  add_markers(color = factor(clustering_data$clust))%>%
  layout(scene = list(xaxis = list(title = "Meat Products"),
                      yaxis = list(title = "Fruit Products"),
                      zaxis = list(title = "Gold Products")),
         paper_bgcolor = 'rgb(243,243,243)')



#joining the clusters back to the main dataset
marketing_data_slim$dbo_clust <- clustering_data$clust
marketing_data_slim$k_mean_clust <- clustering_data$kmean_clust

#Getting summary stats for dbscan cluster number 2
marketing_data_slim %>% 
  filter(dbo_clust == 2) %>%
  select(Education,Marital_Status,Income,Recency) %>%
  summary()

#Getting summary stats for k-means cluster number 2 for comparison
marketing_data_slim %>% 
  filter(k_mean_clust == 2) %>%
  select(Education,Marital_Status,Income,Recency) %>%
  summary()
