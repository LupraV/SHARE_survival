cd "/Users/lvmacpro/Desktop/788A3"
use "SHARE8waves.dta", clear

*Converting negative values to missing
foreach var of varlist ph006d1-ph006d21 ph006dot {
replace `var' = . if `var' < 0
}
foreach var of varlist ph067_1-ph067_4 ph069_1-ph069_4 ph072_1-ph072_4 ph075_1-ph075_4 {
replace `var' = . if `var' < 0
}
foreach var of varlist euro1-euro12 {
replace `var' = . if `var' < 0
}
replace ends_meet = . if ends_meet < 0
replace thinc_m = . if thinc_m < 0
replace ep005_ = . if ep005_ < 0
replace chronic_mod = . if chronic_mod < 0
replace mobilityind = . if mobilityind < 0
replace isced1997_r = . if isced1997_r < 0
replace hhsize = . if hhsize < 0
replace partnerinhh = . if partnerinhh < 0
replace female = . if female < 0
replace sphus = . if sphus < 0

*Remove digits before Country Name
generate country_name = ""
replace country_name = "Austria" if country == 11
replace country_name = "Germany" if country == 12
replace country_name = "Sweden" if country == 13
replace country_name = "Netherlands" if country == 14
replace country_name = "Spain" if country == 15
replace country_name = "Italy" if country == 16
replace country_name = "France" if country == 17
replace country_name = "Denmark" if country == 18
replace country_name = "Greece" if country == 19
replace country_name = "Switzerland" if country == 20
replace country_name = "Belgium" if country == 23
replace country_name = "Israel" if country == 25
replace country_name = "Czech Republic" if country == 28
replace country_name = "Poland" if country == 29
replace country_name = "Ireland" if country == 30
replace country_name = "Luxembourg" if country == 31
replace country_name = "Hungary" if country == 32
replace country_name = "Portugal" if country == 33
replace country_name = "Slovenia" if country == 34
replace country_name = "Estonia" if country == 35
replace country_name = "Croatia" if country == 47
replace country_name = "Lithuania" if country == 48
replace country_name = "Bulgaria" if country == 51
replace country_name = "Cyprus" if country == 53
replace country_name = "Finland" if country == 55
replace country_name = "Latvia" if country == 57
replace country_name = "Malta" if country == 59
replace country_name = "Romania" if country == 61
replace country_name = "Slovakia" if country == 63

*Combining all cumulative health events into negative shocks:
gen byte neg_HShocks = 0
replace neg_HShocks = 1 if ph006d1 ==1 | ph006d2 ==1 | ph006d3 ==1 | ph006d4 ==1 | ph006d5 ==1 | ph006d6 ==1 | ph006d7 ==1 | ph006d8 ==1 | ph006d9 ==1 | ph006d10 ==1 | ph006d11 ==1 | ph006d12 ==1 | ph006d13 ==1 | ph006d14 ==1 | ph006dot ==1 | ph006d15 ==1 | ph006d16 ==1 | ph006d17 ==1 | ph006d18 ==1 | ph006d19 ==1 | ph006d20 ==1 | ph006d21 ==1

*Acute health shocks – (new) since last interview: (heart attack, stroke, hip/femoral fracture)
gen byte acute_HShock = 0
replace acute_HShock = 1 if ph067_1 ==1 | ph067_2 ==1 | ph067_4 ==1 | ph069_1 ==1 | ph069_2 ==1 | ph069_4 ==1 | ph072_1 ==1 | ph072_2 ==1 | ph072_4 ==1 | ph075_1 ==1 | ph075_2 ==1 | ph075_4 ==1

*Combine all cumulative psychological distress events into shocks:
gen byte neg_PsyShocks = 0
replace neg_PsyShocks = 1 if euro1 ==1 | euro2 ==1 | euro3 ==1 | euro4 ==1 | euro5 ==1 | euro6 ==1 | euro7 ==1 | euro8 ==1 | euro9 ==1 | euro10 ==1 | euro11 ==1 | euro12 ==1

*Log monthly income (reverting back to Euros from thousands to avoid getting negative log for income < Eur1000/m)
replace thinc_m = . if thinc_m <= 0
gen float log_inc_m = log(thinc_m*1000) if thinc_m > 0

*Create new binary/categorical/dummy variables

*Employment Status
gen byte employ_status = .
replace employ_status = 0 if ep005_ == 97
replace employ_status = 1 if ep005_ == 1
replace employ_status = 2 if ep005_ == 2
replace employ_status = 3 if ep005_ == 3
replace employ_status = 4 if ep005_ == 4
replace employ_status = 5 if ep005_ == 5
label define employ_status_labels 0 "Other" 1 "Retired" 2 "Employed or self-emp." 3 "Unemployed" 4 "Perm. sick or disabled" 5 "Homemaker"
label variable employ_status "Employment Status"
label values employ_status employ_status_labels

*Inactive/Active in Labour Market
gen byte exit_labourforce = .
replace exit_labourforce = 0 if employ_status == 2 | employ_status == 3
replace exit_labourforce = 1 if employ_status == 1 | employ_status == 4 | employ_status == 5

*Financial strain (ends not/barely met)
gen byte ends_notmet = .
replace ends_notmet = 1 if ends_meet <=2
replace ends_notmet = 0 if ends_meet > 2 

*Chronic Diseases
gen byte chronic_d = .
replace chronic_d = 0 if chronic_mod ==0
replace chronic_d = 1 if chronic_mod > 0

*Low Mobility
gen byte low_mobility = .
replace low_mobility =0 if mobilityind < 3
replace low_mobility =1 if mobilityind >= 3

* Education level
generate byte education_level = .
replace education_level = 1 if isced1997_r == 5 | isced1997_r == 6
replace education_level = 2 if isced1997_r == 4
replace education_level = 3 if isced1997_r == 3
replace education_level = 4 if isced1997_r <= 2
replace education_level = 5 if isced1997_r > 6
label define education_level_labels 1 "University Degree" 2 "Diploma/Certificate" 3 "Secondary Education" 4 "Basic Education" 5 "Other Education"
label values education_level education_level_labels
label variable education_level "Education Level"

*Household composition
generate byte hh_comp = .
replace hh_comp = 1 if hhsize == 1
replace hh_comp = 2 if hhsize == 2
replace hh_comp = 3 if hhsize > 2
label define hh_comp_labels 1 "Solo Household" 2 "Two-person Household" 3 "Three or more person Household"
label values hh_comp hh_comp_labels
label variable hh_comp "Household Composition"

*Living with Partner/Spouse
gen byte partner_hh = 0
replace partner_hh = 1 if partnerinhh == 1

*Renaming variable SPHUS (Likert type variable)
rename sphus SPH
label variable SPH "Self-Perceived Health"
label define SPH_labels 1 "Excellent" 2 "Very Good" 3 "Good" 4 "Fair" 5 "Poor"
label values SPH SPH_labels

*Grouping binary variable for SPH (Good vs. Poor Health)
gen SPH_binary = (SPH >= 4)
label define SPH_binary_labels 0 "Excellent/Very Good/Good" 1 "Fair/Poor"
label values SPH_binary SPH_binary_labels

*Create official retirement age variable by country and gender (rounded up for simplification)
generate byte retirement_age = .
replace retirement_age = 67 if inlist(country_name, "Denmark", "Netherlands", "Bulgaria", "Spain", "Italy", "Portugal", "Greece")
replace retirement_age = 66 if inlist(country_name, "Germany", "Ireland")
replace retirement_age = 65 if inlist(country_name, "Belgium", "Czech Republic", "Estonia", "Finland", "Cyprus", "Latvia") 
replace retirement_age = 65 if inlist(country_name, "Luxembourg", "Lithuania", "Slovenia", "Hungary", "Israel", "Switzerland")
replace retirement_age = 64 if inlist(country_name, "Malta", "Slovakia")
replace retirement_age = 63 if inlist(country_name, "Sweden", "France")
replace retirement_age = 61 if country_name == "Austria" & female == 1
replace retirement_age = 65 if country_name == "Austria" & female == 0
replace retirement_age = 64 if country_name == "Croatia" & female == 1
replace retirement_age = 65 if country_name == "Croatia" & female == 0
replace retirement_age = 60 if country_name == "Poland" & female == 1
replace retirement_age = 65 if country_name == "Poland" & female == 0
replace retirement_age = 62 if country_name == "Romania" & female == 1
replace retirement_age = 65 if country_name == "Romania" & female == 0
label variable retirement_age "Official retirement age by country and gender"

*Create an unique ID for each individual and add labels
sort country_name mergeid wave
egen panelID = group(mergeid)
label variable age "Age"
label variable female "Gender (1=Female, 0=Male)"
label variable country_name "Country Name"
label variable acute_HShock "Acute Health Shock (new)"
label variable neg_HShocks "Cumulative Negative Health Shocks (all)"
label variable neg_PsyShocks "Cumulative Psychological Shocks (all)"
label variable log_inc_m "Log of Monthly Household Income"
label variable exit_labourforce "Exited Labour Force/Inactive"
label variable ends_notmet "Financial Strain (Ends not/barely Met)"
label variable chronic_d "Has Chronic Diseases"
label variable low_mobility "Has Low Mobility"
label variable partner_hh "Living with Partner in Household"

*Create subset keeping only needed variables
keep mergeid wave panelID country_name female age retirement_age SPH SPH_binary chronic_d low_mobility neg_HShocks acute_HShock neg_PsyShocks thinc_m log_inc_m employ_status exit_labourforce ends_notmet education_level hh_comp partner_hh
save SHARE_subset.dta, replace





