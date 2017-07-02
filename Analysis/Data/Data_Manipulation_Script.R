############################################################################################
#  General Section
############################################################################################
setwd("C:\\Users\\X\\Documents\\SMU\\DoingDataScience\\PPanek_CaseStudy1\\Analysis")
library(tidyr)
library(dplyr)
library(ggplot2)

# Data - Reading it in and getting familiar with it.
############################################################################################

# Reading Data
Beers <- read.csv("Data\\Beers.csv",header=TRUE)
Breweries <- read.csv("Data\\Breweries.csv",header=TRUE)

# Preserving Original Data Tables
BeersOriginal <- Beers
BreweriesOriginal <- Breweries

# First Review of Data
head(BeersOriginal)
# Data appears clean
# ABV and IBU variables are not intuitive and should be renamed
# NA values for IBU
# Otherwise the Data appear clean

dim(BeersOriginal)
# 2,410 rows and 7 columns

summary(BeersOriginal)
# Names appear multiple times - Possible duplicate records
# 62 NAs in ABV and 1005 in IBU.  Significant for IBU.

str(BeersOriginal)
# First Name starts with "#001" which is a Potential error.  Should sort by name and look for issues if data is used.
# Should Re-Name Name variable to reduce potential ambiguity.

head(BreweriesOriginal)
# Data looks good, but should rename the Name Variable, and the Brew_ID variable.

dim(BreweriesOriginal)
# 558 rows and four columns

summary(BreweriesOriginal)
# Certain Breweries appear more than Once.  Possible Duplicates.  May not be if in different Cities or States.
# Should rename Brew_ID so it matches Brewery_ID in Beers (at least for Merge).  Brewery_ID is more descriptive.

str(BreweriesOriginal)
# 551 levels of Brewery Names, so seven duplicates.  Need to review.
# No NAs.

##########################################################################################################
# Looking for other Data issues with the Data and Merging the Files
##########################################################################################################

#  Checking for Duplicate Records
Breweries[duplicated(BreweriesOriginal),]
Beers[duplicated(BeersOriginal),]
#  None in either file.

# Renaming Variables
Breweries<-rename(BreweriesOriginal,BreweryName=Name,Brewery_ID=Brew_ID)
Beers<-rename(BeersOriginal,BeerName=Name,AlcoholbyVolume=ABV,BitternessUnit=IBU,Brewery_ID=Brewery_id)
# Making the names more descriptive and matching the Variable to Merge on.
# Old name of Brew_Id could be ambiguous since some folks call Beers "Brews".

# Checking to see that the Name Change worked as expected.
head(Beers)
head(Breweries)

# Merging the files
BeerMerged1 <- merge(Beers,Breweries, by = "Brewery_ID", all = TRUE)
head(BeerMerged1)  # Check Merge, Looks OK

########################################################################################################
# Reviewing the Duplicate Brewery Names
########################################################################################################

# Checking for Brewery$Names with multiple Brewery IDs.
BreweriesOriginal$Name[which(duplicated(BreweriesOriginal$Name) == TRUE)]
# Seven potential duplicates.  Will need to evaluate the merged file to see how they are used.
# If truly duplicate and meaningful to the results will need to eliminate the records in
# Breweries and change the Brewery ID in Beers.

# The process I used to look at these duplicates is somewhat long and is potentially distracting.
# Because I opted not to adjust any of the data, I have saved that code in a separate file, Dupe_Breweries.
# The process consisted of three steps:
#    1) Looking at the Breweries File to see why they were shown as duplicates, and to get the Brewery IDs.
#    2) Looking at the Merged file to see how ofthen the relevant IDs were used.
#    3) Deciding what to do.  In the end, only in one case was the state affected, and I was reasonably certain that 
#       the number of breweries should be reduced by five.  In two additional cases it is possible that the number of
#       breweries should be reduced by 1.

# I also performed a visual inspection of Brewery Names to see if there were some that were not duplicates but could be.
# The command used was sort(BreweriesOriginal$Name).  I have commented it out here because I didn't want to take up the space
# with the output.

#  The Visual inspection yielded the following results to focus on:

# Against the Grain Brewery           Against The Grain Brewery             Typo in Name
# Angry Minnow                        Angry Minnow Brewing Company          Probably the same
# Goose Island Brewery Company        Goose Island Brewing Company          One and the same. Maybe a space at end?
# Hops & Grain Brewery                Hops & Grains Brewing Company         Probably the same
# Mother Earth Brew Company           Mother Earth Brewing Company          This is OK, they are in Different States   
# Oskar Blues Brewery                 Oskar Blues Brewery (North Carol...   This is OK.  No Change (NC and CO)

# the code to evaluate these is in Dupe_Breweries.

# Again, because the number of brewery records is overstated by either two or four depending on the desired level of
# certainty, I opted not to change the data. Since it wasn't in the requirement, I also wasn't sure if changing the data would make your task
# more difficult.





