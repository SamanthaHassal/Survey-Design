###Preamble###
# This code is a draft version of the code in the .Rmd file that produces the 2nd level model
# in order for this code to run, the chunks in the .Rmd file that clean the CES data and GSS data need to be run

#create a vector of provinces that appear in both datasets 
#(the CES data includes the territories, while the GSS doesn't)
provinces <- unique(ps_var_of_interest$province)

#add quant variables to the data frame
var_of_interest$BQ <- BQ
var_of_interest$NDP <- NDP
var_of_interest$liberal <- liberal
var_of_interest$conservative <- conservative
var_of_interest$green <- green
var_of_interest$sat_score <- score
var_of_interest$has_higher_ed <- education

#select only records in provinces in both data sets
working_file <- var_of_interest %>%
  filter(cps19_province %in% provinces)

#empty vector for storage (we will need one of these for each model)
out_green <- matrix(ncol = length(provinces), nrow = 4)
out_liberal <- matrix(ncol = length(provinces), nrow = 4)
out_conservative <- matrix(ncol = length(provinces), nrow = 4)
out_ndp <- matrix(ncol = length(provinces), nrow = 4)
out_bq <- matrix(ncol = length(provinces), nrow = 4)

#loop over provinces, building models for each
for (i in seq_along(provinces))
{
  tmp <- working_file %>% filter(working_file$cps19_province==provinces[i])
  tmp_model_C <- glm(tmp$conservative ~ tmp$cps19_age+tmp$has_higher_ed+tmp$sat_score, 
                   data=tmp, 
                   family="binomial")
  tmp_model_BQ <- glm(tmp$BQ ~ tmp$cps19_age+tmp$has_higher_ed+tmp$sat_score, 
                     data=tmp, 
                     family="binomial")
  tmp_model_NDP <- glm(tmp$NDP ~ tmp$cps19_age+tmp$has_higher_ed+tmp$sat_score, 
                     data=tmp, 
                     family="binomial")
  tmp_model_green <- glm(tmp$green ~ tmp$cps19_age+tmp$has_higher_ed+tmp$sat_score, 
                       data=tmp, 
                       family="binomial")
  tmp_model_liberal <- glm(tmp$liberal ~ tmp$cps19_age+tmp$has_higher_ed+tmp$sat_score, 
                         data=tmp, 
                         family="binomial")
  out_green[, i] <- tmp_model_green$coefficients
  out_ndp[, i] <- tmp_model_NDP$coefficients
  out_liberal[, i] <- tmp_model_liberal$coefficients
  out_bq[, i] <- tmp_model_BQ$coefficients
  out_conservative[, i] <- tmp_model_C$coefficients
} 

#generate L2 model coefficients
L2_coef_C <-  c(mean(out_conservative[1]), 
                mean(out_conservative[2]),
                mean(out_conservative[3]),
                mean(out_conservative[4]))
L2_coef_liberal <-  c(mean(out_liberal[1]), 
                mean(out_liberal[2]),
                mean(out_liberal[3]),
                mean(out_liberal[4]))
L2_coef_ndp <-  c(mean(out_ndp[1]), 
                      mean(out_ndp[2]),
                      mean(out_ndp[3]),
                      mean(out_ndp[4]))
L2_coef_bq <-  c(mean(out_bq[1]), 
                  mean(out_bq[2]),
                  mean(out_bq[3]),
                  mean(out_bq[4]))
L2_coef_green <-  c(mean(out_green[1]), 
                 mean(out_green[2]),
                 mean(out_green[3]),
                 mean(out_green[4]))

