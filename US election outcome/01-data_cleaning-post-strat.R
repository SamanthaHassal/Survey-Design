# ### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from https://usa.ipums.org/
# Author: Samantha Hassal and Ting Fu Hsu
# Data: 22 October 2020
# Contact: tingfu.hsu@utoronto.ca, samantha.hassal@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to same file as the code
# - Don't forget to gitignore it!


#install.packages('labelled')
#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data. 
raw_data <- read_dta("usa_00002.dta"
                     )
# Add the labels
raw_data <- labelled::to_factor(raw_data)

# Just keep some variables that may be of interest (change 
# this depending on your interests)
names(raw_data)

reduced_data <- 
  raw_data %>% 
  select(region,
         stateicp,
         empstat,
         sex, 
         age, 
         race, 
         hispan,
         marst, 
         bpl,
         citizen,
         educd,
         labforce,
         inctot)
rm(raw_data)


# ### What's next? ####

# +
#Remove Non-Citizens (Can't vote, therefore not included)
'%!in%' <- function(x,y)!('%in%'(x,y))
notVoteAge <- 1:17
canVote <- reduced_data %>% 
  filter(citizen %in% c("n/a", "naturalized citizen", "born abroad of American parents")) %>% 
  filter(age %!in% notVoteAge & age != "less than 1 year old")

#data.frame(education, working_file$age, working_file$state, employ, voter_prior_behave)

#Narrow down to the swing states "north carolina", "florida", "pennsylania", "michigan", "arizona", "wisconsin", "ohio"
canVote <- canVote %>% 
  filter(stateicp %in% c("north carolina", "florida", "pennsylvania", "michigan", "arizona", "wisconsin", "ohio"))

#Vector of Education:
degrees <- c("associate's degree, type not specified",
               "associate's degree, occupational program",
               "associate's degree, academic program",
               "bachelor's degree",
               "master's degree",
               "doctoral degree",
               "professional degree beyond a bachelor's degree")

#Having degree = Higher level of education
hasDegree <- ifelse(canVote$educd %in% degrees, 1, 0)

#Employment vector
isEmployed <- ifelse(canVote$empstat == "employed", 1, 0)

postStratData <- data.frame(hasDegree, canVote$age, canVote$stateicp, isEmployed)

#post-stratification data using coefficients from the level 1 model
PS_lev1 <- (-1.28474587+0.02274943*as.numeric(postStratData$canVote.age)[1:1216]
            -0.11797110*as.numeric(postStratData$hasDegree)[1:1216]
            +0.38548255*as.numeric(postStratData$isEmployed)[1:1216]
)
#post-stratification data using coefficients from the level 2 model
means <- c(mean(unlist(mylist_1, use.names=FALSE)), 
           mean(unlist(mylist_2, use.names=FALSE)), 
           mean(unlist(mylist_3, use.names=FALSE)), 
           mean(unlist(mylist_4, use.names=FALSE)))
#seed
set.seed(length(swing$vote_2020))
#normal distributions
sd1 <- rnorm(1216, 0, sd(unlist(mylist_1)))
sd2 <- rnorm(1216, 0, sd(unlist(mylist_2)))
sd3 <- rnorm(1216, 0, sd(unlist(mylist_3)))
sd4 <- rnorm(1216, 0, sd(unlist(mylist_4)))
#add them up
rndm_crp_2 <- sd1+sd2+sd3+sd4
PS_lev2 <- (means[1]+means[2]*as.numeric(postStratData$canVote.age)[1:1216]
            +means[3]*as.numeric(postStratData$hasDegree)[1:1216]
            +means[4]*as.numeric(postStratData$isEmployed)[1:1216]+rndm_crp_2)

ggplot(postStratData[1:1216,], aes(x=as.numeric(postStratData$canVote.age[1:1216])+
                                     as.numeric(postStratData$hasDegree)[1:1216]+
                                     as.numeric(postStratData$isEmployed)[1:1216], y=PS_lev1)) + 
  geom_point() + geom_smooth(method=lm , color="pink", fill='blue', se=TRUE) + 
  labs(title="Level 1 graph of likelihood of Trump win", subtitle="Data from ACS survey (2020)", x="predicting factors (age, employment, education)", y='log of odds ratio')


ggplot(postStratData[1:1216,], aes(x=as.numeric(postStratData$canVote.age[1:1216])+
                            as.numeric(postStratData$hasDegree)[1:1216]+
                            as.numeric(postStratData$isEmployed)[1:1216], y=PS_lev2)) + 
  geom_point() + geom_smooth(method=lm , color="pink", fill='blue', se=TRUE) + 
  labs(title="Level 2 graph of likelihood of Trump win", subtitle="Data from ACS survey (2020)", x="predicting factors (age, employment, education)", y='log of odds ratio')


#TEMPORARY CITATION:
#Steven Ruggles, Sarah Flood, Ronald Goeken, Josiah Grover, Erin Meyer, Jose Pacas and Matthew Sobek. IPUMS USA: Version 10.0 [dataset]. Minneapolis, MN: IPUMS, 2020.
#https://doi.org/10.18128/D010.V10.0
# -




