clear all 

******************************
	global output_dir C:\Users\mjors_000\Dropbox\TOPICTHESIS\Out
	global output_dir2 C:\Users\mjors_000\Dropbox\TOPICTHESIS\Out2
	global data_dir C:\Users\mjors_000\Dropbox\WAVE_2\Sample_Berenger\
adopath + "C:\Users\mjors_000\Dropbox\WAVE_2\Ado" 
*****************************  

*use "C:\Users\mjors_000\Dropbox\WAVE_2\Sample_Berenger\Nig14_final_dataset_BERENGER.dta", clear
use $data_dir\Nig14_final_dataset_BERENGER.dta

drop crop_labor_dry crop_inputs_dry crop_inputs_oth_dry hid 

/*KEEPING ONLY LAND USERS OR CROP PRODUCERS*/
tab dum_cropresid_1

keep if dum_cropresid_1!=.
*keep if dum_organ_fert !=.

* Labeling variables values
*label define value 1"yes" 0"no"
label values d_imprseed value

ren climvar dum_subjective_neg_affected


*Generating modern inputs variables*
gen modern_inputs_1= (dum_inorgan_fert_1==1 | d_imprseed==1) if dum_inorgan_fert_1!=. | d_imprseed!=.

label values modern_inputs_1 values
* Households Characteristics*
gen ln_farmsize=ln(land_area+1)
gen ln_areacultiv=ln(landcul+1)
gen ln_educ=log(educhead+1)
g ageheadsqure = agehead*agehead
g logage = ln(agehead +1)
g logagehead2= ln(ageheadsqure+1)
gen ln_hhsize =ln(hhsize+1)
gen ln_distextension_servoffice = log(distextension_servoffice+1)
gen ln_distpermanent_market = log(distpermanent_market+1)
gen ln_total_livstocksize= ln(TLU_total+1)
g logmin10km = ln(m_10km + 1)
g log_hhsize_adulteq= ln(eqadu+1)
recode ln_distpermanent_market ln_distextension_servoffice (.=0)

label variable logage "log of age of the user"
label variable ageheadsqure " age squre of user"
label variable logagehead2 "log of age squre of user"
label variable ln_educ "log of years education head of hh"
label variable ln_hhsize "log of hh size"
label variable ln_farmsize "log of farm size"
label variable ln_distpermanent_market "Distance from the nearest permanent or periodic market"
label variable ln_distextension_servoffice " Distance from the nearest Agric Extension Office"
label variable ln_total_livstocksize " log of total livestock size"
label variable logmin10km " log road density 10 km radius"

label variable dum_cropresid_1 " Crop Residue"
label variable dum_organ_fert_1 " Organic Fertilizer"
label variable modern_inputs_1 " Modern Inputs"

label variable precip_z_low " Negative Rainfall Shock (Drought)"
label variable precip_z_high "Positive Rainfall Shock"

label variable poor " Household below National Poverty Line"
label variable dsmall "Small Farmer"
label variable agr_extension "Access to Agricultural Extension Services"
label variable anti_erosion "Erosion control"
label variable dum_subjective_neg_affected "hh reports negatively affected by droughts/irr. of rain in last 12 months"
la var log_hhsize_adulteq "log of hhsize in terms of adults equivalents"

ren d_own land_ownership

/*
g dum_livstock=(ln_total_livstocksize>0)

***I generate an interaction variable for low rainfall shock and livestock size
gen lowrain_livestock= precip_z_low*ln_total_livstocksize
label variable lowrain_livestock "Livestock size * Negative rainfall shock"

gen drought_livestock= precip_z_low*dum_livstock
gen flood_livestock= precip_z_high*dum_livstock

*****SET THE DATASET INTO PANEL DATA******
xtset hhid year

************REGRESSION: EFFECTS OF EXPOSURE TO CLIMATE STRESS  ON TECHNOLOGY ADOPTION******************

e
***REGRESSION********
**CLUSTER FIXED EFFECTS

***************Rainfall and Temperature shocks and adoption*****
***cluster-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "PSU-Year FE"
reghdfe `var'  extra_temp_max29 precip_z_low drought_livestock precip_z_high , a(psu year) vce(cluster psu)
eststo `var'
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_clim2.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(Cluster-Year/Household-Year Fixed Effects Estimation) /*addtext(Year FE, Yes, Yes, Yes)*/

}
*coefplot (dum_cropresid_1, label(Crop Residue)) (dum_organ_fert_1, label(Organic Fertilizer)) (modern_inputs_1, label(Modern Inputs)) , drop(_cons) xline(0)

***hhid-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "HHID-Year FE"
reghdfe `var' extra_temp_max29 precip_z_low drought_livestock precip_z_high , a(hhid year) vce(cluster psu)
eststo
outreg2 using $output_dir/Regression_adoption_cluster_yearFE_clim2.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(Cluster-Year/Household-Year Fixed Effects Estimation)
}
*coefplot (dum_cropresid_1, label(Crop Residue)) (dum_organ_fert_1, label(Organic Fertilizer)) (modern_inputs_1, label(Modern Inputs)) , drop(_cons) xline(0)

 
 
 
 

 
***************Rainfall and Temperature shocks and adoption : NO AG EXTENSION SAMPLE*****
***cluster-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "PSU-Year FE"
reghdfe `var' extra_temp_max29 0.agr_extension precip_z_low precip_z_high c.extra_temp_max29#0.agr_extension precip_z_low#0.agr_extension precip_z_high#0.agr_extension if poor==0 , a(psu year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_no_ag.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(Cluster-Year/Household-Year Fixed Effects Estimation)
}

***hhid-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "HHID-Year FE"
reghdfe `var' extra_temp_max29 0.agr_extension precip_z_low precip_z_high c.extra_temp_max29#0.agr_extension precip_z_low#0.agr_extension precip_z_high#0.agr_extension if poor==0, a(hhid year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_no_ag.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(Cluster-Year/Household-Year Fixed Effects Estimation)
}

*
***************Rainfall and Temperature shocks and adoption : ACCESS AG EXTENSION SAMPLE*****
***cluster-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "PSU-Year FE"
reghdfe `var'  extra_temp_max29 agr_extension precip_z_low precip_z_high c.extra_temp_max29#1.agr_extension precip_z_low#agr_extension precip_z_high#agr_extension if poor ==1, a(psu year) vce(cluster psu) 
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_agext.xls, pval bdec(3) rdec(3) label excel cttop(`lab') 
}

***hhid-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "HHID-Year FE"
reghdfe `var'  extra_temp_max29 agr_extension precip_z_low precip_z_high c.extra_temp_max29#1.agr_extension precip_z_low#agr_extension precip_z_high#agr_extension if poor==1, a(hhid year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_agext.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(P-values in parantheses)
}

*


***********Restricting the sample to Poor only (below Poverty line)
******ON POOR
***cluster-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "PSU-Year FE"
reghdfe `var'  extra_temp_max29 poor precip_z_low precip_z_high c.extra_temp_max29#1.poor precip_z_low#poor precip_z_high#poor, a(psu year) vce(cluster psu)

eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_rain_only_poor.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(P-values in parantheses)
}

***hhid-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "HHID-Year FE"
reghdfe `var' extra_temp_max29 poor precip_z_low precip_z_high c.extra_temp_max29#1.poor precip_z_low#poor precip_z_high#poor , a(hhid year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_rain_only_poor.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(P-values in parantheses)
}

******ON RICH
***cluster-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "PSU-Year FE"
reghdfe `var' extra_temp_max29 0.poor precip_z_low precip_z_high c.extra_temp_max29#0.poor , a(psu year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_rain_only_rich.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(P-values in parantheses)
}

***hhid-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1  {
local lab "HHID-Year FE"
reghdfe `var' extra_temp_max29 0.poor precip_z_low precip_z_high c.extra_temp_max29#0.poor , a(hhid year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_rain_only_rich.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(P-values in parantheses)
}
*



**************************Temperature shock#land size and adoption*****
***cluster-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1 {
local lab "PSU-Year FE"
reghdfe `var' c.extra_temp_max29##c.ln_farmsiz , a(psu year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_tempe_farmsize.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(P-values in parantheses)
}

***hhid-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1 {
local lab "HHID-Year FE"
reghdfe `var' c.extra_temp_max29##c.ln_farmsiz , a(hhid year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_tempe_farmsize.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(P-values in parantheses) append
}
*
*********************************Rainfall shock#land size and adoption*****
***cluster-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1 {
local lab "PSU-Year FE"
reghdfe `var' precip_z_low 1.precip_z_high ln_farmsiz  1.precip_z_low#c.ln_farmsiz 1.precip_z_high#c.ln_farmsiz, a(psu year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_rain_farmsi.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(P-values in parantheses)
}

***hhid-year fixed effects
foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1 {
local lab "HHID-Year FE"
reghdfe `var' precip_z_low 1.precip_z_high ln_farmsiz  1.precip_z_low#c.ln_farmsiz 1.precip_z_high#c.ln_farmsiz, a(hhid year) vce(cluster psu)
eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE_rain_farmsi.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(P-values in parantheses) append
}
*





************WITH PSU YEAR FIXED EFFECTS

foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1 {
local lab "PSU-Year FE"
reghdfe `var' extra_temp_max29 precip_z_low lowrain_livestock precip_z_high   ///
ln_farmsize poor land_ownership d_mobile wealth ln_hhsize ln_total_livstocksize, a(psu year) vce(cluster psu)

eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(Cluster-Year/Household-Year Fixed Effects Estimation)
}


************WITH HH FIXED EFFECTS

foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1 {
local lab "HHID-Year FE"
reghdfe `var' extra_temp_max29 precip_z_low lowrain_livestock precip_z_high   ///
ln_farmsize poor land_ownership d_mobile wealth ln_hhsize ln_total_livstocksize, a(hhid year) vce(cluster psu)

eststo
outreg2 using $output_dir2/Regression_adoption_cluster_yearFE.xls, pval bdec(3) rdec(3) label excel cttop(`lab') addnote(Cluster-Year/Household-Year Fixed Effects Estimation) 
}


***********HAUSMAN TEST (Fixed effects vs Random Effects) ******

foreach var of varlist dum_cropresid_1 dum_organ_fert_1  modern_inputs_1 {
xtreg `var' extra_temp_max29 1.precip_z_low 1.precip_z_high poor 1.agr_ext_specific_ever ln_farmsize land_ownership   ///
log_hhsize_adulteq logage ln_educ femhead flaborshare d_mobile  ///
 wealth agrassetT d_sandy_soil d_loamy_soil d_clay_soil d_groundgraze_soil d_hill_topog d_plain_topog d_gentleslope_topog ///
d_steepslope_topog d_valley_topog ln_total_livstocksize dum_subjective_neg_affected ///
 dummy_irrigation dummy_cooperative  ln_distextension_servoffice  ln_distpermanent_market, fe
 
est store `var'fe
xtreg `var' extra_temp_max29 1.precip_z_low 1.precip_z_high poor 1.agr_ext_specific_ever ln_farmsize land_ownership   ///
log_hhsize_adulteq logage ln_educ femhead flaborshare d_mobile  ///
 wealth agrassetT d_sandy_soil d_loamy_soil d_clay_soil d_groundgraze_soil d_hill_topog d_plain_topog d_gentleslope_topog ///
d_steepslope_topog d_valley_topog ln_total_livstocksize dum_subjective_neg_affected ///
 dummy_irrigation dummy_cooperative  ln_distextension_servoffice  ln_distpermanent_market, re
est store `var'

hausman `var'fe `var'

}

/******CONCLUSION : FIXED EFFECTS SHOULD BE USED: because for each dependent variable 
the hausman test shows that we reject H0 at 99.99% (P-value=0.00000) meaning that fixed effects is appropriate because random effects coeffs are biased.
*/





