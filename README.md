# Customer Segmentation Analysis Using DBSCAN

## Project Overview
The goal of this project was to see if using DBSCAN on customer data would produce meaningful clusters of customers.
I will also being running a standord k-means clusting algorithum. Both algorithums produced meaningful groups of customers
the DBSCAN was able to produces small and more tightly knit groups of customers. One downside of the DBSCAN algorithum is that
you need to set a value of epsilon and a miniumn number of values that will be used to make a cluster. This was done by using the 
kNNdistplot that is in the dbscan library, but this still required some guess and checking on the users side to find a good value 
for both epsilon and the niniumn number of points.


## Data Files

### halfmoon_example.csv
This file has the data that is needed to run the Halfmoon_Example file.

### Marketing_campaign.csv
This file has the data that is used for the DBSCAN anlaysis.

## R Files

### Halfmoon_Example.R
This file has the code that is used to produce the following plot as exmaple of the difference between
k-means clustering and DBSCAN clustering <br />


<img align="left" alt="DBSCAN" width="7000px" src="https://github.com/patrickA25/patrickA25/blob/assets/DBSCAN_Principle.png" /> 

<br />

### Data Exploration and DBSCAN Analysis.R

This file has the code that was used in the analysis for the marketing campaign data. It will go through 
all of the steps of data cleaning and explorations, running both the k-menas clustering, running the
DBSCAN, and procduing the following 3D graphics. 


<img align="left" alt="DBSCAN" width ="450px" src="https://github.com/patrickA25/patrickA25/blob/assets/DBSCAN_plot1.png" />
<img align="left" alt="DBSCAN" width="450px" src="https://github.com/patrickA25/patrickA25/blob/assets/k_means_3d_plot3.png" />
