# install cesR package
devtools::install_github("hodgettsp/cesR")

# load cesR package and labelled package
library(cesR)
library(labelled)

# call 2019 CES online survey
get_ces("ces2019_web")

# convert values to factor type
ces2019_web <- to_factor(ces2019_web)

#code to look at all the different variables in the data set
parameters <- colnames(ces2019_web)
parameters

#filter date values
library(readr)
library(dplyr)

options <- ces2019_web %>%
select(cps19_education)
unique(options)

edu_demsat <- ces2019_web %>%
select(cps19_education, cps19_demsat)

low_level <- edu_demsat %>%
filter(cps19_education=="Completed secondary/ high school")

medium_level <- edu_demsat %>%
  filter(cps19_education=="Bachelor's degree")

high_level <- edu_demsat %>%
filter(cps19_education=="Master's degree")

unknown <- edu_demsat %>%
filter(cps19_education=="Don't know/ Prefer not to answer")

#install graphing
install.packages(
   "ggplot2",
   repos = c("http://rstudio.org/_packages",
   "http://cran.rstudio.com")
)

#plot data
library(ggplot2)

bar_low <- ggplot(low_level, aes(x=cps19_demsat)) + geom_bar() +labs(title="Satisfaction with Democracy at Lowest Education Level", subtitle="Data from cesR (2019)", x="satisfaction with democracy", y='number of responses')
bar_low + coord_flip()

bar_medium <- ggplot(medium_level, aes(x=cps19_demsat)) + geom_bar() + labs(title="Satisfaction with Democracy at Medium Education Level", subtitle="Data from cesR (2019)", x="satisfaction with democracy", y='number of responses')
bar_medium + coord_flip()

bar_high <- ggplot(high_level, aes(x=cps19_demsat)) + geom_bar() +labs(title="Satisfaction with Democracy at Highest Education Level", subtitle="Data from cesR (2019)", x="satisfaction with democracy", y='number of responses')
bar_high + coord_flip()

bar_unknown <- ggplot(unknown, aes(x=cps19_demsat)) + geom_bar() +labs(title="Satisfaction with Democracy at Unknown Education Level", subtitle="Data from cesR (2019)", x="satisfaction with democracy", y='number of responses')
bar_unknown + coord_flip()

#generate unique set for reference purposes
options <- edu_demsat %>%
  select(cps19_demsat)
unique(options)

#look at unknown satisfaction with democracy
unknown2 <- edu_demsat %>%
filter(cps19_demsat=="Don't know/ Prefer not to answer")
unknown2

#graph data
unknown2 <- edu_demsat %>%
filter(cps19_demsat=="Don't know/ Prefer not to answer")
bp_unknowm <- ggplot(unknown2, aes(x=cps19_education)) + geom_bar() + labs(title="Unknown satisfaction with democracy", subtitle="Data from cesR (2019)", x="education level", y='number of responses')
bp_unknowm + coord_flip()

#create citations
citation("cesR")
citation("ggplot2")
citation()
