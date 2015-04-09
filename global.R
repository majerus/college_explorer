library(dplyr)
library(zipcode)
library(RCurl)
library(zipcode)
library(ggthemes)

x <- getURL("https://raw.githubusercontent.com/majerus/college_map/master/data/superzip.csv")
allzips <- read.csv(text = x)

#allzips <- readRDS("data/superzip.rds")
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)
#allzips$college <- allzips$college * 100


allzips$zip <- clean.zipcodes(allzips$HD2013.ZIP.code)


row.names(allzips) <- allzips$unitid

allzips$state.x <- ifelse(is.na(allzips$state.x) & allzips$city.x=='Washington', 'D.C.', as.character(allzips$state.x))  # make DC a state so it is not missing from analysis

# transform variables 
allzips$l_enorllment <- log(allzips$DRVEF122013.12.month.full.time.equivalent.enrollment..2012.13 + 1)
allzips$ID <- allzips$zipcode

allzips$city.x <- as.character(allzips$city.x)

cleantable <- allzips %>%
  select(
    Institution = institution.name, 
    City = city.x,
    State = state.x,
    Zipcode = zip,
    #Rank = rank,
    Tuition = centile,
    #Superzip = superzip,
    Enrollment = adultpop,
    Selectivity = college,
    Applications = income,
    Lat = latitude,
    Long = longitude, 
    ID = zipcode
  )


# handle missing data 
allzips$college <- ifelse(is.na(allzips$college), 101, allzips$college)  # missing admit rates to 101 so they work with adjustable selectivity 
allzips[is.na(allzips)] <- 0  # all other missing values to 0 
allzips <- na.omit(allzips) # rows that are still missing values are dropped 




# temporarily remove colleges with missing data 
# cleantable <- na.omit(cleantable)

