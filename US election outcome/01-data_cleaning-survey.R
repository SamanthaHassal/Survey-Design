# ### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from https://www.voterstudygroup.org/downloads?key=8513750c-0fa5-4134-b572-f5bdba414828
# Author: Samantha Hassal
# Data: 22 October 2020
# Contact: samantha.hassal@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the data from X and save the folder that you're 
# interested in to inputs/data 
# - Don't forget to gitignore it!


#install.packages('tidyverse')
#install.packages('haven')
#install.packages('labelled')

#### Workspace setup ####
library(haven)
library(tidyverse)
# Read in the raw data (You might need to change this if you use a different dataset)
raw_data <- read_dta("ns20200625.dta")
# Add the labels
raw_data <- labelled::to_factor(raw_data)
# Just keep some variables
reduced_data <- 
  raw_data %>% 
  select(interest,
         registration,
         vote_2016,
         vote_intention,
         vote_2020,
         ideo5,
         employment,
         foreign_born,
         gender,
         census_region,
         hispanic,
         race_ethnicity,
         household_income,
         education,
         state,
         congress_district,
         age)


# ### What else???? ####
# Maybe make some age-groups?
# Maybe check the values?
# Is vote a binary? If not, what are you going to do?

# +
#only look at registered voters who intend to vote
working_file <- reduced_data %>%
filter(registration=='Registered') %>%
filter(vote_intention!='No, I will not vote but I am eligible') %>%
filter(vote_2020 %in% c("Donald Trump", "Joe Biden"))

working_file

# +
#build age quartiles
age_quartile <- quantile(working_file$age)

#build vector of education levels
high_ed <- c("Associate Degree", 
             "Completed some college, but no degree", 
             "Masters degree", 
             "Completed some graduate, but no degree", 
             "Other post high school vocational training",
            "Doctorate degree",
            "College Degree (such as B.A., B.S.)") 
education <- ifelse(working_file$education %in% high_ed, 1, 0)

#build vector of employment
is_employed <- c("Full-time employed", "Self-employed", "Part-time employed")
employ <- ifelse(working_file$employment %in% is_employed, 1, 0)

#build vector of prior voting behaviour
voter_prior_behave <- ifelse(working_file$vote_2016=="Donald Trump", 1, 0)

#build vector of intended vote
intend_vote <- ifelse(working_file$vote_2020=="Donald Trump", 1, 0)
# -
#construct new data frame
election_DF <- data.frame(education, working_file$age, working_file$state, employ, voter_prior_behave, intend_vote)
#examine swing states only
sw_states <- c("AZ", "FL", "GA", "MI", "MN", "NC", "PA", "WI")
swing <- election_DF %>%
filter(working_file.state %in% sw_states)

#GLM model with age, employment, education
my_model_1 <- glm(swing$intend_vote ~ swing$working_file.age+swing$education+swing$employ, data=swing, family="binomial")
my_model_1
confint(my_model_1)


#GLM model with age, employment, education, and prior voting behaviour
my_model_2 <- glm(swing$intend_vote ~ swing$working_file.age+swing$education+swing$employ+swing$voter_prior_behave, data=swing, family="binomial")
my_model_2
confint(my_model_2)

# +
#function to transform imput data as per model 1
outcome <- function(age, edu, emp) {
  Y <- (coef(my_model_1)["swing$working_file.age"]*age
        + coef(my_model_1)["swing$education"]*edu
        + coef(my_model_1)["swing$employ"]*emp
       + coef(my_model_1)["(Intercept)"])
y <- exp(Y)
    return(y)
}

T <- outcome(swing$working_file.age, swing$education, swing$employ)


# +
#function to transform imput data as per model 2
outcome_2 <- function(age, edu, emp, prior) {
  Y <- (coef(my_model_2)["swing$working_file.age"]*age
        + coef(my_model_2)["swing$education"]*edu
        + coef(my_model_2)["swing$employ"]*emp
        + coef(my_model_2)["swing$voter_prior_behave"]*prior
       + coef(my_model_2)["(Intercept)"])
y <- exp(Y)
    return(y)
}

U <- outcome_2(swing$working_file.age, swing$education, swing$employ, swing$voter_prior_behave)

# +
# preliminary graphical analyses
library(ggplot2)
 
ggplot(swing, aes(x=working_file.age+education+employ, y=log(T))) + 
    geom_point() + geom_smooth(method=lm , color="pink", fill='blue', se=TRUE) +
  labs(title="Level 1 graph of likelihood of Trump win", subtitle="Data from NationScape Survey (2020)", x="predicting factors (age, employment, education)", y='log of odds ratio')


ggplot(swing, aes(x=working_file.age+education+employ+voter_prior_behave, y=log(U))) + 
    geom_point() + geom_smooth(method=lm , color="blue", fill='pink', se=TRUE) +
  labs(title="Level 1 graph of likelihood of Trump win given 2016 voting behaviour", subtitle="Data from NationScape Survey (2020)", x="predicting factors (age, employment, education)", y='log of odds ratio')



# +
#empty lists
mylist_1 <- list()
mylist_2 <- list()
mylist_3 <- list()
mylist_4 <- list()
#loop over swing states, building models for each and inputting coefficients into lists
for (state in sw_states)
{
tmp <- swing %>% filter(swing$working_file.state==state)
tmp_model <- glm(tmp$intend_vote ~ tmp$working_file.age+tmp$education+tmp$employ, data=tmp, family="binomial")
mylist_1[state] <- coef(tmp_model)[1]
mylist_2[state] <- coef(tmp_model)[2]
mylist_3[state] <- coef(tmp_model)[3]
mylist_4[state] <- coef(tmp_model)[4]
} 

#seed
set.seed(length(swing$vote_2020))
#normal distributions
s1 <- rnorm(swing$intend_vote, 0, sd(unlist(mylist_1)))
s2 <- rnorm(swing$intend_vote, 0, sd(unlist(mylist_2)))
s3 <- rnorm(swing$intend_vote, 0, sd(unlist(mylist_3)))
s4 <- rnorm(swing$intend_vote, 0, sd(unlist(mylist_4)))
#add them up
rndm_crp <- s1+s2+s3+s4
#outcome function after level 2 regression
outcome_strat_by_state <- function(age, edu, emp) {
    Y <- (mean(unlist(mylist_2, use.names=FALSE))*age
        + mean(unlist(mylist_3, use.names=FALSE))*edu
        + mean(unlist(mylist_4, use.names=FALSE))*emp
       + mean(unlist(mylist_1, use.names=FALSE)))
y <- exp(Y+rndm_crp)
    return(y)
}
# -
M <- outcome_strat_by_state(swing$working_file.age, swing$education, swing$employ)
ggplot(swing, aes(x=working_file.age+education+employ, y=log(M))) + 
    geom_point() + geom_smooth(method=lm , color="pink", fill='blue', se=TRUE) + 
  labs(title="Level 2 graph of likelihood of Trump win", subtitle="Data from NationScape Survey (2020)", x="predicting factors (age, employment, education)", y='log of odds ratio')







