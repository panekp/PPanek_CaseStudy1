############################################################################################
#  General Section
############################################################################################
setwd("C:\\Users\\X\\Documents\\SMU\\DoingDataScience\\PPanek_CaseStudy1\\Analysis")
library(tidyr)
library(dplyr)
library(ggplot2)

# Data-Reading and Creating the Merged File So the Data_Manipulation_Script does not need to be run.
#########################################################################################################

# Reading Data
Beers <- read.csv("Data\\Beers.csv",header=TRUE)
Breweries <- read.csv("Data\\Breweries.csv",header=TRUE)
# Preserving Original Data Tables
BeersOriginal <- Beers
BreweriesOriginal <- Breweries
# Renaming
Breweries<-rename(BreweriesOriginal,BreweryName=Name,Brewery_ID=Brew_ID)
Beers<-rename(BeersOriginal,BeerName=Name,AlcoholbyVolume=ABV,BitternessUnit=IBU,Brewery_ID=Brewery_id)
# Merging
BeerMerged1 <- merge(Beers,Breweries, by = "Brewery_ID", all = TRUE)
head(BeerMerged1)  # Check Merge, Looks OK


################################################################################################
## Analysis and Output
################################################################################################

# Question 1 How Many Breweries in each state?
table(Breweries$State)
ggplot(Breweries,aes(factor(Breweries$State)))+geom_bar()+labs(x="State")+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=8))

#  The number of Breweries in each state where there are breweries can be seen int the table above.
#  The number ranges from 1 (DC, ND, SD and WV) to 47 in CO.  There are 51 observations, including DC,
#  so 10 states are not represented, or have no Breweries.


# Question 2 Merge the two files and Print the Head and Tail
# File was Merged earlier
head(BeerMerged1)
tail(BeerMerged1)

# Both ends of the data look reasonable.  The number of NAs In BitternessUnit is notable.

#  Question 3: The Number of NAs in each Column
apply(BeerMerged1, 2, function(x) {sum(is.na(x))})

#  There are 62 NAS in AlocoholbyVolume, and 1,005 in BitternessUnit out of 2,410 observations.


#  Question 4:  Median Alcohol Content and Bitteness by State

# Creating a Data frame for the values to plot.  I know this was inefficient, but had to stop with the research and use brute force.
Bitmedians<-tapply(BeerMerged1$BitternessUnit,BeerMerged1$State,median,na.rm = TRUE)
AlcMedians<-tapply(BeerMerged1$AlcoholbyVolume,BeerMerged1$State,median,na.rm = TRUE)
Statelist<-c("AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY")
#  I understand the risk of doing it this way, and inspected the results to make sure that Statelist values lined up with the row names.
StateMedians<-data.frame(Bitmedians,AlcMedians,Statelist)
names(StateMedians)<-c("Bitmedians","AlcMedians","State")

ggplot(StateMedians,aes(x=StateMedians$State, y=StateMedians$AlcMedians))+geom_bar(stat = "identity")+labs(x="State", y="Median Alcohol Content by Volume",title = "Median Beer Alcohol Content By State")+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=8))
# Median Alcohol Content is relatively stable accross States. 
ggplot(StateMedians,aes(x=StateMedians$State, y=StateMedians$Bitmedians))+geom_bar(stat = "identity")+labs(x="State", y="Median Int'l Bitterness Units",title = "Median Beer Bitterness By State")+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=8))
# There is a fair amount of variation in the Median Bitterness Unit by State, with the highest median approximately 3X the lowest.


# Getting number of Not NA observations to evaluate quality of Medians
AlcoholByStateNotNA <- tapply(BeerMerged1$AlcoholbyVolume,BeerMerged1$State,function(x) {sum(!is.na(x))})
BitterByStateNotNA <- tapply(BeerMerged1$BitternessUnit,BeerMerged1$State,function(x) {sum(!is.na(x))})
NotNAByState <- data.frame(BitterByStateNotNA,AlcoholByStateNotNA,Statelist)
names(NotNAByState)<-c("NotNABit","NotNAAlc","State")
ggplot(NotNAByState,aes(x=NotNAByState$State, y=NotNAByState$NotNABit))+geom_bar(stat = "identity")+labs(x="State", y="Observations with Valid Bitterness Units",title = "Observations with Valid Bitterness Units By State")+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=8))
ggplot(NotNAByState,aes(x=NotNAByState$State, y=NotNAByState$NotNAAlc))+geom_bar(stat = "identity")+labs(x="State", y="Observations with Valid Alcohol Content",title = "Observations with Valid Alcohol Content By State")+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=8))
# as can be seen from the graps above, the medians in certain states is quite small.


#  Question 5: States where the beer with the highest alcohol content and the most bitter beer are brewed.
BeerMerged1[which(BeerMerged1$AlcoholbyVolume == max(BeerMerged1$AlcoholbyVolume, na.rm = TRUE)),10]
#State in which the beer with the highest alcohol content is Brewed is CO.

#State with the Most Alcoholic Content by volume is Oregon
BeerMerged1[which(BeerMerged1$BitternessUnit == max(BeerMerged1$BitternessUnit, na.rm = TRUE)),10]
#State in which the beer with the highest alcohol content is Brewed is OR.

# Question 6:  Summary Statistics for Alcohol by Volume
summary(BeerMerged1$AlcoholbyVolume)
# Alcohol content ranges from .1% to 12.8% with a meab of 5.977% and a Median of 5.6%.  The data appears slightly right-skewed.


# Question 7:  Relationship between Bitterness and Alcoholic Content
ggplot(BeerMerged1,aes(BeerMerged1$AlcoholbyVolume,BeerMerged1$BitternessUnit))+geom_point(alpha=1/5)+labs(x="Alcohol Content", y="Bitterness Unit",title = "Alcohol Content and Bitterness of Beer in the US")

# There appears to be a positive correlation between Alcohol Content and Bitterness.  The relationship appear
# stronger above approximatelt 6% Alcohol COntent, and may not be linear.

# A Note on Variables (IBU)

# Data issues noted but not fixed.

#  a) It appears that multiple years of data may be used because some BeerNames have years in them.  The distinction between same names with different years attached is unknown.  
#     It could be distinction between the different vintages of recipes or a year's production.
#  b) Certain cities may be wrong.  Some typos ("St Paul" vs St. Paul) and may be flat-out errors.  Left unchanged intentionally because City Name is not a dimension of this study,
#     and I have a bias toward leaving data unchanged unless there is a compelling reason to do so and I do so based on knowledge of the facts.

#  c) BeerNames have special Characters in them.  I have not eliminated.

