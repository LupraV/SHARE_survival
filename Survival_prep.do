*Survival Analysis (Set up preparation)
use "SHARE_subset.dta", clear

*Exclude missing values in variables: SPH, exit_labourforce, employ_status, age
drop if SPH == . | exit_labourforce == . | employ_status == . | age == . | retirement_age == .
keep if age >49 & age < retirement_age

*Keep only individuals who were at least aged 50 and half-year prior to retirement age at their initial wave 
bysort panelID (wave): gen initial_age = age[1] 
bysort panelID (wave): gen initial_wave = wave[1]
keep if initial_age > 50 & initial_age < retirement_age - 1

*Define event, entry time (t0) and exit time (t1)
sort panelID wave
gen byte event = exit_labourforce
bysort panelID: gen t0 = age[_n-1]
bysort panelID: replace t0 = initial_age if _n == 1
gen t1 = age
drop if missing(t0) | t0 >= t1

*Adjust for Retirement Age (different by country and gender)
gen byte reached_retirement_age = age >= retirement_age
bysort panelID (wave): gen temp_ret_age = age if reached_retirement_age == 1 & (reached_retirement_age[_n-1] == 0 | _n == 1)
bysort panelID: egen retirement_age_entry = min(temp_ret_age)

*Censoring at exit wave -1 (early labour exits)
gen censor_age = retirement_age_entry - 1
* Individuals who never got to retirement age, set censor_wave to last wave 
bysort panelID: egen last_age = max(age) 
replace censor_age = last_age if missing(retirement_age_entry)
replace censor_age = initial_age if censor_age < initial_age

*Adjust t1 and event for censoring and attrition
gen t1_adj = min(t1, censor_age)
replace event = 0 if t1 >= censor_age & event == 0

*Attrition
bysort panelID: egen last_wave = max(wave)
bysort panelID: gen byte attrition = 0
bysort panelID: replace attrition = 1 if wave == last_wave & event == 0 & age < retirement_age - 1
replace t1_adj = age if attrition == 1 & t1_adj > age
replace event = 0 if attrition == 1

drop temp_ret_age last_age last_wave

*Encode 'country_name' as numeric variable 
encode country_name, gen(country_id) 
label variable country_id "Country"

*Set up Survival data
* Ensure t0 < t1_adj 
drop if t0 >= t1_adj 
*Set up survival data with censoring just before retirement age 
stset t1_adj, id(panelID) enter(t0) failure(event)

*Save
save SHARE_survival.dta, replace
