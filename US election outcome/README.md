# Overview

This repo contains code and data for forecasting the US 2020 presidential election. It was created by Ting Fu Hsu, Samantha Hassal. The purpose is to create a report that summarises the results of a statistical model that we built. Some data is unable to be shared publicly. We detail how to get that below. The sections of this repo are: inputs, outputs, scripts.

Inputs contain data that are unchanged from their original. We use two datasets: 

- [Survey data - detail how to get the survey data.]
  The full data set can be accessed through 
  https://www.voterstudygroup.org/publication/nationscape-data-set 
  by entering your name and email address at the bottom of the page to submit a 
  request. The link to download the data will be provided in the email sent by 
  them.
  
 
- [ACS data - detail how to get the ACS data.]
To access the ACS data, you must first go to 
https://usa.ipums.org/usa/index.shtml 
and log in / register. Then, navigate to "create your custo. data set" in the 
homepage, or "https://usa.ipums.org/usa-action/variables/group". Then, under
"SELECT SAMPLES", only the 2018 ACS data was used. Then, the following
harmonized variables are chosen:

Variables Selected:

YEAR (Census year)
SAMPLE (IPUMS sample identifier)
SERIAL (Household serial number)
CBSERIAL (Original Census Bureau household serial number)
HHWT (Household weight)
CLUSTER (Household cluster for variance estimation)
REGION (Census region and division)
STATEICP (State (ICPSR code))
CITY (City)
STRATA (Household strata for variance estimation)
GQ (Group quarters status)
PERNUM (Person number in sample unit)
PERWT (Person weight)
SEX (Sex)
AGE (Age)
MARST (Marital status)
RACE (Race [general version])
RACED (Race [detailed version])
HISPAN (Hispanic origin [general version])
HISPAND (Hispanic origin [detailed version])
BPL (Birthplace [general version])
BPLD (Birthplace [detailed version])
CITIZEN (Citizenship status)
EDUC (Educational attainment [general version])
EDUCD (Educational attainment [detailed version])
EMPSTAT (Employment status [general version])
EMPSTATD (Employment status [detailed version])
LABFORCE (Labor force status)
INCTOT (Total personal income)
MIGPLAC1 (State or country of residence 1 year ago)

Then, it was downloaded in .dta format (modifiable after going to your cart)


Outputs contain data that are modified from the input data, the report and supporting material.
They are contained in the outputs/paper folder. The files are the following:

- paper.pdf (The generated report from paper.Rmd)
- paper.Rmd (The RMarkdown file used to generate the paper)

Scripts contain R scripts that take inputs and outputs and produce outputs. These are:

- 01_data_cleaning.R
- 02_data_preparation.R

ALL references are contained at outputs/paper/references.bib



