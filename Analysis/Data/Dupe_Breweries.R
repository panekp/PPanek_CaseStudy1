#  Checking the Data Sets for Duplicate Breweries.
#  Some of the inspection was done on the Merged Data Set to see how frequently some of the Brewery IDs were used.

# Duplicate Breweries
#########################################################################################
# Checking for Brewery$Names with multiple Brewery IDs.
BreweriesOriginal$Name[which(duplicated(BreweriesOriginal$Name) == TRUE)]
# Seven potential duplicates.  Will need to evaluate the merged file to see how they are used.
# If truly duplicate and meaningful to the results will need to eliminate the records in
# Breweries and change the Brewery ID in Beers.

#  Finding the Brewery_IDs for each Brewery Name so I can look at the full record.
BeerMerged1[BeerMerged1$BreweryName == "Oskar Blues Brewery",]   
#  Reviewed use of IDs 167 & 504. Both used repeatedly.
#  Decided to keep both IDs unchanged.  Two IDs are in two different Cities, but in the same state.

BeerMerged1[BeerMerged1$BreweryName == "Sly Fox Brewing Company",]
#  Reviewed use of IDs 164 & 372.
#  Cities are different, and ID 164 is only used once.  That is likely an error, but am not certain.

BeerMerged1[BeerMerged1$BreweryName == "Blackrocks Brewery",]
#  Two different states, Google Search reveals Brewery in MI not MA.
#  96 is used, so change 96 to 13,in Beers file and drop 96 in Breweries, then re-Merge, or change the state and Brewery ID in the record with 96.

BeerMerged1[BeerMerged1$BreweryName == "Blue Mountain Brewery",]
#  Reviewed use of IDs 383 & 415.
# 415 is only used once and may be an error.

BeerMerged1[BeerMerged1$BreweryName == "Summit Brewing Company",] ## CHECK DONE
# Typo in City (St Paul vs St. Paul).  Left Unchanged.  IDs 59 & 139

BeerMerged1[BeerMerged1$BreweryName == "Otter Creek Brewing",] ## CHECK DONE
#  IDs 276, 262. are in two different Cities.  Google search indicates that 276 is correct at this time.  Leave unchaged, because I don't know the time dimension of
#  data so 262 may have been correct.  Since I am not knowlegeable enough and the dimension is not part of this analysis I will leave unchanged. 

BeerMerged1[BeerMerged1$BreweryName == "Lucette Brewing Company",]  ## CHECK DONE
#  City name is mis-spelled, on 378.  457 is correct, Menominee should be Menominie.  Based on Google search.


# Breweries with Similar names
####################################################################################################################

#  Printing Names for visual inspection
sort(BreweriesOriginal$Name)

#  Focused on these names as a result of visual Inspection
BeerMerged1[which(substring(BeerMerged1$BreweryName,1,5)=="Oskar"),]  
BeerMerged1[which(substring(BeerMerged1$BreweryName,1,6)=="Mother"),] 
BeerMerged1[which(substring(BeerMerged1$BreweryName,1,5)=="Goose"),]  
BeerMerged1[which(substring(BeerMerged1$BreweryName,1,7)=="Against"),]
BeerMerged1[which(substring(BeerMerged1$BreweryName,1,5)=="Angry"),]
BeerMerged1[which(substring(BeerMerged1$BreweryName,1,6)=="Hops &"),]

# Against the Grain Brewery           Against The Grain Brewery             Typo in Name
# Angry Minnow                        Angry Minnow Brewing Company          Probably the same
# Goose Island Brewery Company        Goose Island Brewing Company          One and the same. Maybe a space at end?
# Hops & Grain Brewery                Hops & Grains Brewing Company         Probably the same
# Mother Earth Brew Company           Mother Earth Brewing Company          This is OK, they are in Different States   
# Oskar Blues Brewery                 Oskar Blues Brewery (North Carol...   This is OK.  No Change (NC and CO)

