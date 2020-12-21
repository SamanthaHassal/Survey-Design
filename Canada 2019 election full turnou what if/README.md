# Introduction

This folder contains:

1. my .Rmd notebook

2. a .gitignore file (some of the data can't be made publicly available)

3. an .RProj file

4. some loose code I put together (testing space)

# Data retrieval:

CES data: simply install the cesR library using the following command: devtools::install_github("hodgettsp/cesR")

GSS data: to access the GSS data, you will need to do the following
1. log into the CHASS (Computing for Humanities And Social Sciences) page: http://dc.chass.utoronto.ca/myaccess.html

2. click on "SDA @ CHASS" - log in with your credentials

3. this will take you to a page with two language options. Continue in English

4. you should now be at a webpage with all the datasets handled by SDA in alphabetical order. Go to "G", and click on "General Social Surveys"

5. find the 2017 GSS data - click on the link that says "data"

6. select all the variables, with data definitions for STATA

7. save the data as a CSV file

8. run the data cleaning code in the file marked "gss data cleaning" (you will need to move your download into this folder to do this -  more instructions in the data cleaning code itself)

9. copy the output file into the same directory as the .Rmd notebook
