clear                                                                                                   
clear matrix                                                                                            
capture clear                                                                                           
capture log close                                                                                       
set mem 500m                                                                                            
set matsize 800                                                                                         
set more off     
                                                                                         
*************************************************************************************                                                                                                        
*************************************************************************************                    
**                                                                                 **                    
** Country: Niger                                                                  **                    
** Data Source: Enquete Nationale sur les Conditions de Vie des Menages - Niger    **                    
** Year: 2014                                                                      **                    
** Program: Crop_level			     									  	   **
** Output:	$TEMP/Niger14.dta												   **		
*************************************************************************************                     
*************************************************************************************
                                                                                                      
cd  C:\Users\mjors_000\Dropbox\WAVE_2\Dofiles                                                      
log using C:\Users\mjors_000\Dropbox\WAVE_2\Log\Niger14.log, replace                               
adopath + "C:\Users\mjors_000\Dropbox\WAVE_2\Ado"                                                   
                                                                                                        
global IN		C:\Users\mjors_000\Dropbox\WAVE_2\Data                                   
global RAW		C:\Users\mjors_000\Dropbox\WAVE_2\RAWDATA\Food_welfare                               
global DO 	C:\Users\mjors_000\Dropbox\WAVE_2\Dofiles                                 
global OUT		C:\Users\mjors_000\Dropbox\WAVE_2\Out                                       
global TEMP 	C:\Users\mjors_000\Dropbox\WAVE_2\Tempdata                                  
global HHCHAR   C:\Users\mjors_000\Dropbox\WAVE_2\Dofiles\HHCharact
global SAMPLE1  C:\Users\mjors_000\Dropbox\WAVE_2\Sample_Berenger
global SAMPLE2  C:\Users\mjors_000\Desktop\ECON628-01-berenger92\My_thesis_project
*************
** GENERAL **
*************
** Data Source: Enquete Nationale sur les Conditions de Vie des Menages 2014 - 2015 (ECVMA)                     
** 3,478 Households, out of which 2,261 are RURAL and 1,217 are URBAN 

u $IN\Sample.dta, clear

merge 1:1 hhid using $RAW\ECVMA2014welfare_T1c.dta, keepus(hgender dtot hage)
ta _m
*drop if _merge ==1
drop _m
ren dtot hhexp

merge 1:1 hhid using $OUT\all_soil_variables.dta, keepus(d_sandy_soil d_loamy_soil d_clay_soil d_groundgraze_soil d_other_soil d_hill_topog d_plain_topog d_gentleslope_topog d_steepslope_topog ///
 d_valley_topog d_other_topog d_land_title d_trad_certificate d_certicate_of_sale d_other_type d_no_land_title prop_anti_erosion_measure1 prop_anti_erosion_measure2 prop_anti_erosion_measure3 prop_anti_erosion_measure4 prop_irrigation_yes ///
 prop_irrigation_no dummy_erosion dummy_irrigation prop_irrigation_yes prop_irrigation_no prop_property_typ1 prop_property_typ2 prop_property_typ3 prop_property_typ4 prop_property_typ5 prop_soil_topogr1 prop_soil_topogr2 prop_soil_topogr3 ///
 prop_soil_topogr4 prop_soil_topogr5 prop_soil_topogr6 prop_soil_qual1 prop_soil_qual2 prop_soil_qual3 prop_soil_qual4 prop_soil_qual5)

ta _m
*drop if _merge ==1
drop _m

sort hhid

/*merge 1:1 hhid using $OUT\Nig14_inputs.dta, keepus(qfert_ha qchem_ha qseed_ha totvchem totvfert totvseed fertexp_ha chemexp_ha seedexp_ha)
ta _m
drop if _merge ==2
drop _m
la var totvchem "Total Value of Chemicals Used"
la var totvfert "Total Value of Fertilizers used"
la var totvseed "Total Value of Seed used"

merge 1:1 hhid using $OUT\onfarmlabor.dta, keepus(total_men_days total_women_days family_days)
ta _m
drop _m*/

merge 1:1 hhid using $OUT\Niger_production.dta, keepus(dcrop_prod /*foodprod foodprod1 cropincome1gross yield_vha yield_total yield_vpc yield_kgha yield_tons_ha*/)
ta _m
drop _m

merge 1:1 hhid using $OUT\crop_parcel_all_rainy.dta, keepus(crop_inputs_rainy_adj)
ta _m
drop _m

merge 1:1 hhid using $OUT\crop_income.dta, keepus(v_crop_transf_rainy crop_harv_kg_rainy crop_harv_rainy crop_sales_charges_rainy value_harvest_rainy value_harvest_rainy_uml crop_transf_rainy crop_transf_rainy_uml crop_rev1_rainy cropincome1)
ta _m
drop _m

merge 1:1 hhid using $OUT\Nig14_inputchoices.dta
ta _m
drop _m

merge 1:1 hhid using $OUT\Crop_diversity_index.dta
ta _m
drop _m

merge 1:1 hhid using $OUT\diversity_income.dta
ta _m
drop _m

merge 1:1 hhid using $OUT\diversity_labour.dta
ta _m
drop _m

merge 1:1 hhid using $OUT\Nig14_lines2.dta
ta _m
drop _m

merge 1:1 hhid using $OUT\Nig14_mech.dta, keepus(thhagasset thhagassetimp agrassetNT agrassetT)
recode thhagasset thhagassetimp agrassetNT agrassetT (.=0)
ta _m
drop _m

merge 1:1 hhid using $OUT\Nig14_livst.dta, keepus(foodownliv)
ta _m
drop if _merge==2
drop _m

merge 1:1 hhid using $OUT\Nig14_tech.dta, keepus(d_imprseed)
*ren d_imprseed MVadoption
ta _m
drop _m

merge 1:1 hhid using $OUT\Nig14_transf.dta, keepus(pubtrans)
ren pubtrans pubtransfer
ta _m
drop _m

merge 1:1 hhid using $OUT\poverty_indices.dta, keepus(calories food  DES EXP ADER ADES DES_cereals MDER FPL FPHC FPG FSP pcexpusd exppcday PHC PG SP)
ta _m
drop _m

merge 1:1 hhid using $OUT\niger14_pc_tech_durables.dta, keepus(hhdurvalimp_tech hhdurtech )
ta _m
drop _m


merge 1:1 hhid using $OUT\niger14_pc_tech_no_durables.dta, keepus(hhdurvalimp hhdurnotech wealth wealth wealth_urb wealth_rur)
ta _m
drop _m
gen hhdurval= hhdurvalimp

merge 1:1 hhid using $OUT\Food.dta, keepus(foodowncrop)
ta _m
drop _m

merge 1:1 hhid using $OUT\other_vars2.dta
ta _m
*keep if _merge==3
drop _m

merge 1:1 hhid using $OUT\otherhhchar_dummies.dta
ta _m
*keep if _merge==3
drop _m

merge 1:1 hhid using $OUT\otherhhchar_dummies.dta
ta _m
drop _m

merge 1:1 hhid using $HHCHAR\niger14_hc.dta, keepus(femhead agehead hhlabor flabor flaborshare educave educadult educhead d_mobile d_computer hhsize d_internet)
*drop health_exp health_assist d_mosquito d_prenatal_care d_prenatal_expert d_prenatal_public health_prenatal d_livebirth d_abortion_expert d_abortion_public health_abortion d_contraception d_condom hh
recode femhead agehead hhlabor flabor flaborshare educave educadult educhead d_mobile d_computer d_internet (.=0)
ta _m
drop _m

merge 1:1 hhid using $HHCHAR\niger14_pc_livestock.dta, keepus( tvalanim tvalanimimp cfcamel TLU_total)
ta _m
drop _m

merge 1:1 psu hhid using $HHCHAR\niger14_infrastructure.dta, keepus( distextension_servoffice distperiodic_market distpermanent_market distprschool distsecschool disthealth distbus distroad distbank distpost)
ta _m
drop _m

merge 1:1 hhid using $HHCHAR\niger14_nc.dta, keepus( d_own land_area landcul ilandcul rlandcul landnotcul landrent landloan landoth landown ilandown rlandown landquint landless)
ta _m
drop _m

merge 1:1 hhid using $HHCHAR\niger14_village_char.dta, keepus( dummyhelp_system_field dummy_cooperative dummy_tractor dummy_irrig_programme)
ta _m
drop _m

merge 1:1 hhid using $OUT\climateshocks.dta
ta _m
drop _m

merge 1:1 hhid using $OUT\Total_income.dta, keepus(totincome tot_income_USD tot_income2_USD pc_income_USD pc_income2_USD pc_Adult_income2_USD pc_Adult_income_USD Quintile_pc_adult_incomeUSD)
ren totincome income_tot
gen income_tot2 = income_tot
ta _m
drop _m

merge 1:1 hhid using "C:\Users\mjors_000\Dropbox\WAVE_1\dta\sample_final2.dta" , keepus( m_10km m_15km m_20km  kmm_10km kmm_15km kmm_20km)
ta _m
drop _m

merge 1:1 hhid using "C:\Users\mjors_000\Dropbox\TOPICTHESIS\Subjective_climate_reporting\climshockswave2.dta", keepus(climvar)
tab _merge
keep if _m==3
drop _merge


merge 1:1 hhid using $OUT\food_insecurity.dta, keepus(food_insecur)
ta _m
drop _m

recode landquint landless (.=0)
recode cfcamel wealth_urb wealth_rur TLU_total tvalanim tvalanimimp (.=0)

drop if _n==2503 

***Poverty line 2014: national poverty line..National line calculated by INS and is in the variable zref of Welfare dataset
g pl=176621.9					
					
***Generate dummies for being poor 2014 and being small holder (using land size)
g poor=(pcexp<=pl)
g dsmall = (landcul<=6.95)
gen year = 2014

merge m:1 psu year using "C:\Users\mjors_000\Dropbox\TOPICTHESIS\Climate_Data\rainfall_data2014.dta"
keep if _merge==3
sort  hhid psu year
drop _merge 

save $OUT\Nig14_final_dataset2014_ber, replace 

******APPENDING THE WAVE 1 2011 AND WAVE 2 2014********

use "C:\Users\mjors_000\Dropbox\WAVE_1\dta\sample_final2.dta", clear
gen year = 2011
drop property_type1 property_type2 property_type3 property_type4 property_type5 soil_quality1 soil_quality2 soil_quality3 soil_quality4 soil_quality5 soil_topogr1 soil_topogr2 soil_topogr3 soil_topogr4 soil_topogr5 soil_topogr6
drop agr_extension urban strate

****Creating Food Insecurity Variable******
gen  food_insecur= (ms12q04==1) if ms12q06a==8 | ms12q06b==7 | ms12q06c ==8
recode food_insecur (.=0)

sort hhid
drop _merge

/*merging with the soil variables created for wave 1*/
merge 1:1 hhid using "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\Out\all_soil_variables.dta", keepus(d_sandy_soil d_loamy_soil d_clay_soil d_groundgraze_soil d_other_soil d_hill_topog d_plain_topog d_gentleslope_topog d_steepslope_topog ///
 d_valley_topog d_other_topog d_land_title d_trad_certificate d_certicate_of_sale d_other_type d_no_land_title prop_anti_erosion_measure1 prop_anti_erosion_measure2 prop_anti_erosion_measure3 prop_anti_erosion_measure4 prop_irrigation_yes ///
 prop_irrigation_no dummy_erosion dummy_irrigation prop_irrigation_yes prop_irrigation_no prop_property_typ1 prop_property_typ2 prop_property_typ3 prop_property_typ4 prop_property_typ5 prop_soil_topogr1 prop_soil_topogr2 prop_soil_topogr3 ///
 prop_soil_topogr4 prop_soil_topogr5 prop_soil_topogr6 prop_soil_qual1 prop_soil_qual2 prop_soil_qual3 prop_soil_qual4 prop_soil_qual5)

 drop _merge

/*merging distance infrastructures variables*/
merge 1:1 hhid using "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\Out\niger11_infrastructure.dta", keepus (distextension_servoffice distperiodic_market distpermanent_market)
drop _merge

merge 1:1 hhid using "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\Out\niger11_village_char.dta", keepus( dummyhelp_system_field dummy_cooperative dummy_tractor dummy_irrig_programme)
ta _m
drop _m

merge 1:1 hhid using "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\Out\Niger11.dta", keepus(dcrop_prod /*dsmall*/)
ta _m
drop _m

/*merging perception climate change variables : Subjective household perception of climate change*/
merge 1:1 hhid using "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\Out\climateshocks.dta"
drop _merge

merge 1:1 hhid using "C:\Users\mjors_000\Dropbox\TOPICTHESIS\Subjective_climate_reporting\climshockswave1.dta", keepus(climvar)
tab _m
keep if _m==3
drop _merge

/*merging with the crop yield and income created in 2011*/
merge 1:1 hhid using  "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\Out\Nig11_prod_milleteq_per_cap.dta"
drop _merge

/*merging with improved seeds in 2011*/
merge 1:1 hhid using  "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\Tempdata\Nig11_imprvseed.dta", keepus(d_imprseed)
drop _merge

/*merging with input choices in 2011*/
merge 1:1 hhid using  "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\OUT\Nig11_inputchoices.dta"
drop _merge

/*merging with crop income in 2011*/
merge 1:1 hhid using  "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\OUT\cropincome.dta", keepus(v_crop_transf_rainy crop_harv_kg_rainy crop_harv_rainy crop_sales_charges_rainy value_harvest_rainy value_harvest_rainy_uml crop_transf_rainy crop_transf_rainy_uml crop_rev1_rainy cropincome1)
drop _merge

/*merging with input choices in 2011*/
merge 1:1 hhid using  "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\OUT\agricultural_extension_access.dta"
keep if _merge==3
drop _merge


/*merging with poverty line in 2011
merge 1:1 hhid using  "C:\Users\mjors_000\Documents\DAtaFAO\Niger11\Rawdata\ECVMA2011_Welfare.dta", keepus(zref)
drop _merge
*/

***Poverty line 2014: national poverty line..National line calculated by INS and is in the variable zref of Welfare dataset
g pl=182635.2				
					
***Generate dummies for being poor 2014 and being small holder(using land size)
g poor=(pcexp<=pl)

g dsmall = (landcul<=6)

merge m:1 psu year using "C:\Users\mjors_000\Dropbox\TOPICTHESIS\Climate_Data\rainfall_data2011.dta"
keep if _merge==3
sort  hhid psu year
drop _merge 

/*Appending with the WAVE 1 overall dataset*/
append using "C:\Users\mjors_000\Dropbox\WAVE_2\Out\Nig14_final_dataset2014_ber.dta"

drop d_arbor v_arbor  hhsize_WB hgender heduc hsitac7j hsitac12m hbranche hsins hgse property_type1 property_type2 property_type3 property_type4 ///
property_type5 soil_quality1 soil_quality2 soil_quality3 soil_quality4 soil_quality5 soil_topogr1 soil_topogr2 soil_topogr3 soil_topogr4 soil_topogr5 ///
soil_topogr6 hhdurnotech hhdurtech ext dep commune MS00Q14 milieu MS00Q23 MS00Q24 zref village hage depan dalim dnali dtot ndtet v1 deflator geoline ///
foodline med_foodline D_antiCCtemp_measures13 passage ms12q04 ms12q06a ms12q06b ms12q06c MS00Q22 tot_man_days hhweight foodownliv /*totvchem totvfert totvseed qfert_ha qchem_ha qseed_ha fertexp_ha chemexp_ha seedexp_ha */ 
 

/*merge m:1 psu year using "C:\Users\mjors_000\Dropbox\TOPICTHESIS\Climate_Data\rainfall_data.dta"
keep if _merge==3
sort  hhid psu year
drop _merge */

merge m:1 psu year using "C:\Users\mjors_000\Dropbox\TOPICTHESIS\Climate_Data\Out\climatedata.dta"
keep if _merge==3
drop _merge 

merge m:1 psu year using "C:\Users\mjors_000\Dropbox\TOPICTHESIS\Climate_Data\Out\Final_temp_max_28_year.dta"
keep if _merge==3
drop _merge 

merge m:1 psu year using "C:\Users\mjors_000\Dropbox\TOPICTHESIS\Climate_Data\Out\Final_temp_max_29_year.dta"
keep if _merge==3
drop _merge 

sort  hhid psu year
order hhid psu year

****************************************************************************

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

drop ilandcul rlandcul landnotcul landrent landloan landoth landown ilandown rlandown landquint tvalanimimp thhagassetimp educave parcel_D_dry C_crop C_lab C_inc M_crop M_lab M_inc BP_crop BP_lab BP_inc Shannon_crop Shannon_lab Shannon_inc S_crop S_lab S_inc income_tot2 tot_income_USD tot_income2_USD pc_Adult_income_USD pc_Adult_income2_USD pc_income_USD pc_income2_USD Quintile_pc_adult_incomeUSD Quintile_landcul pubtransfer_USD pc_pubtransfer_USD DES EXP ADER ADES DES_cereals MDER FPL FPHC FPG FSP PHC PG SP D_antiCCtemp_measures1 D_antiCCtemp_measures2 D_antiCCtemp_measures3 D_antiCCtemp_measures4 D_antiCCtemp_measures5 D_antiCCtemp_measures6 D_antiCCtemp_measures7 D_antiCCtemp_measures8 D_antiCCtemp_measures9 D_antiCCtemp_measures10 D_antiCCtemp_measures11 D_antiCCtemp_measures12 D_antiCCrain_measures1 D_antiCCrain_measures2 D_antiCCrain_measures3 D_antiCCrain_measures4 D_antiCCrain_measures5 D_antiCCrain_measures6 D_antiCCrain_measures7 D_antiCCrain_measures8 D_antiCCrain_measures9 D_antiCCrain_measures10 D_antiCCrain_measures11 D_antiCCrain_measures12 agr_extension_provider D_agrextension_provider1 D_agrextension_provider2 D_agrextension_provider3 prop_soil_qual1 prop_soil_qual2 prop_soil_qual3 prop_soil_qual4 prop_soil_qual5 prop_soil_topogr1 prop_soil_topogr2 prop_soil_topogr3 prop_soil_topogr4 prop_soil_topogr5 prop_soil_topogr6 prop_property_typ1 prop_property_typ2 prop_property_typ3 prop_property_typ4 prop_property_typ5 foodprod1 cropincome1gross foodprod yield_vha yield_total yield_vpc yield_kgha yield_tons_ha dum_cropresid dum_organ_fert dum_inorgan_fert crop_harv_kg_rainy crop_harv_rainy crop_sales_charges_rainy v_crop_transf_rainy value_harvest_rainy value_harvest_rainy_uml crop_transf_rainy crop_rev1_rainy cropincome1 number_times_received_agric number_times_requested_agric number_times_received number_times_requested 
drop dummy_shock pos_dev_tavg dummy_negative_shock neg_dev_tavg dummy_shock_2 pos_dev_tavg2 dummy_negative_shock2 neg_dev_tavg2 pos_dev_tmin neg_dev_tmin pos_dev_tmin2 neg_dev_tmin2 pos_dev_tmax neg_dev_tmax pos_dev_tmax2 neg_dev_tmax2 covtavg_lt mean_tavg_lt covtavg_st mean_tavg_st mean_tavg_season lagged_tavg lagged_covtavg covtmin_lt mean_tmin_lt covtmin_st mean_tmin_st mean_tmin_season lagged_tmin lagged_covtmin covtmax_lt mean_tmax_lt covtmax_st mean_tmax_st mean_tmax_season lagged_tmax lagged_covtmax tot_rain_flw covrain_lt_flw mean_totrain_lt_flw anomaly_flw pos_dev_rain neg_dev_rain pos_dev_rain2 neg_dev_rain2 extra_temp_max28 l1_extra_temp28 log_hhsize_adulteq hid hh psu year eqadu hhexp pcexp logmin10km agr_extension_current_season agr_extension agr_ext_specific_cur_season agr_ext_specific_ever  dum_pesticides dum_pesticides_1 
drop d_other_topog d_land_title d_trad_certificate d_certicate_of_sale d_other_type d_no_land_title d_other_soil d_groundgraze_soil food_exp

*g irrigation= dummy_irrigation
g tractor = dummy_tractor
g cooperative = dummy_cooperative
g field_help = dummyhelp_system_field
g irrig_programme= dummy_irrig_programme
g dum_cropresid = dum_cropresid_1
g dum_organ_fert = dum_organ_fert_1
g dum_inorgan_fert = dum_inorgan_fert_1
g dum_subjective_neg_affect= dum_subjective_neg_affected
g sandy_soil= d_sandy_soil
g loamy_soil = d_loamy_soil
g clay_soil = d_clay_soil
g hill_topog = d_hill_topog
g plain_topog= d_plain_topog
g gentleslope_topog = d_gentleslope_topog
g steepslope_topog = d_steepslope_topog
g valley_topog = d_valley_topog
g modern_inputs= modern_inputs_1

drop zae d_imprseed d_sandy_soil d_loamy_soil d_clay_soil d_hill_topog d_plain_topog d_gentleslope_topog d_steepslope_topog d_valley_topog dummy_irrigation dummyhelp_system_field dummy_cooperative dummy_tractor dummy_irrig_programme dum_subjective_neg_affected dum_cropresid_1 dum_organ_fert_1 dum_inorgan_fert_1
drop crop_inputs_rainy_adj crop_inputs_oth_rainy_adj crop_transf_rainy_uml crop_labor_dry crop_inputs_dry crop_inputs_oth_dry prop_irrigation_yes prop_irrigation_no prop_anti_erosion_measure1 prop_anti_erosion_measure2 prop_anti_erosion_measure3 prop_anti_erosion_measure4 pubtransfer
drop tvalanim cfcamel hhdurvalimp income_tot calories foodowncrop seed_source kmm_10km kmm_15km kmm_20km total_precip mean_precip sd_precip precip_z

sa $SAMPLE2\Nig14_final_dataset_BERENGER.dta, replace
export delimited using "C:\Users\mjors_000\Desktop\ECON628-01-berenger92\My_thesis_project\dataan.csv", replace
log close
exit
