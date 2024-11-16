use "SHARE_survival.dta", clear


*Kaplan-Meier Survival Analysis

*Kaplan-Meier survival estimates stratified by Acute Health Shock and Gender
sts graph, by(acute_HShock female) ytitle("Proportion Not Exit Labour Market") legend(size(tiny) order(1 "No Acute Health Shock (Male)" 2 "No Acute Health Shock (Female)" 3 "Acute Health Shock (Male)" 4 "Acute Health Shock (Female)")) xtitle("Age") xlabel(50(2)68, labsize(small)) ylabel(0(0.1)1, format(%9.1f) labsize(small)) tmin(50) tmax(68)
*graph export "KM_acuteHS_all.png", replace clear 

*Kaplan-Meier survival estimates stratified by SPH
sts graph, by(SPH) ytitle("Proportion Not Exit Labour Market") legend(size(tiny)) xtitle("Age") xlabel(50(2)68, labsize(small)) ylabel(0(0.1)1, format(%9.1f) labsize(small)) tmin(50) tmax(68) 
*graph export "KM_SPH_all.png", replace clear 

*Kaplan-Meier survival estimates stratified by SPH
*sts graph, by(SPH_binary female) ytitle("Proportion Not Exit Labour Market") legend(size(tiny)) xtitle("Age") xlabel(50(2)68, labsize(small)) ylabel(0(0.1)1, format(%9.1f) labsize(small)) tmin(50) tmax(68) 
*graph export "SPH_survival.png", replace clear 

*K-M Stratified by Country
sts graph, by(country_id) legend(order(1 "Austria" 2 "Belgium" 3 "Bulgaria" 4 "Croatia" 5 "Cyprus" 6 "Czech Republic" 7 "Denmark" 8 "Estonia" 9 "Finland" 10 "France" 11 "Germany" 12 "Greece" 13 "Hungary" 14 "Israel" 15 "Italy" 16 "Latvia" 17 "Lithuania" 18 "Luxembourg" 19 "Malta" 20 "Netherlands" 21 "Poland" 22 "Portugal" 23 "Romania" 24 "Slovakia" 25 "Slovenia" 26 "Spain" 27 "Sweden" 28 "Switzerland") cols(6) size(tiny) lcolor(colorpalette)) ytitle("Proportion Not Exit Labour Market") xtitle("Age", size(small)) xlabel(50(2)68, labsize(small)) ylabel(0(0.1)1, format(%9.1f) labsize(small)) tmin(50) tmax(68) 


foreach country in "Belgium" "Italy" "Spain" { 
    preserve
    keep if country_name == `"`country'"'
    
    * Kaplan-Meier survival estimates stratified by Acute Health Shock and Gender
    sts graph, by(acute_HShock female) ///
        ytitle("Proportion Not Exit Labour Market") ///
        legend(size(tiny) order(1 "No Acute Health Shock (Male)" 2 "No Acute Health Shock (Female)" ///
                                3 "Acute Health Shock (Male)" 4 "Acute Health Shock (Female)")) ///
        xtitle("Age") xlabel(50(2)68, labsize(small)) ///
        ylabel(0(0.1)1, format(%9.1f) labsize(small)) ///
        tmin(50) tmax(68)
    graph export "KM_acuteHS_`country'.png", replace
    
    * Kaplan-Meier survival estimates stratified by SPH for Males
    sts graph if female == 0, by(SPH) ///
        ytitle("Proportion Not Exit Labour Market") ///
        legend(size(tiny)) xtitle("Age") ///
        xlabel(50(2)68, labsize(small)) ///
        ylabel(0(0.1)1, format(%9.1f) labsize(small)) ///
        tmin(50) tmax(68)
    graph export "KM_SPH_M_`country'.png", replace
    
    * Kaplan-Meier survival estimates stratified by SPH for Females
    sts graph if female == 1, by(SPH) ///
        ytitle("Proportion Not Exit Labour Market") ///
        legend(size(tiny)) xtitle("Age") ///
        xlabel(50(2)68, labsize(small)) ///
        ylabel(0(0.1)1, format(%9.1f) labsize(small)) ///
        tmin(50) tmax(68)
    graph export "KM_SPH_F_`country'.png", replace
    
    restore
}

*OR manually:

* Belgium, Italy, Spain, etc
preserve
keep if country_name == "Belgium"

* KM estimates stratified by Acute Health Shock and Gender for Belgium
sts graph, by(acute_HShock female) ytitle("Proportion Not Exit Labour Market") legend(size(tiny) order(1 "No Acute Health Shock (Male)" 2 "No Acute Health Shock (Female)" 3 "Acute Health Shock (Male)" 4 "Acute Health Shock (Female)")) xtitle("Age") xlabel(50(2)68, labsize(small)) ylabel(0(0.1)1, format(%9.1f) labsize(small)) tmin(50) tmax(68)
graph export "KM_acuteHS_Belgium.png", replace

* KM estimates stratified by SPH for Males in Belgium
sts graph if female==0, by(SPH) ytitle("Proportion Not Exit Labour Market") legend(size(tiny)) xtitle("Age") xlabel(50(2)68, labsize(small)) ylabel(0(0.1)1, format(%9.1f) labsize(small)) tmin(50) tmax(68)
graph export "KM_SPH_M_Belgium.png", replace

*KM estimates stratified by SPH for Females in Belgium
sts graph if female==1, by(SPH) ytitle("Proportion Not Exit Labour Market") legend(size(tiny)) xtitle("Age") xlabel(50(2)68, labsize(small)) ylabel(0(0.1)1, format(%9.1f) labsize(small)) tmin(50) tmax(68)
graph export "KM_SPH_F_Belgium.png", replace

restore



*Cox Proportional Hazards Models for Early Exit from Labour Market

*all data
*stcox i.SPH neg_HShocks log_inc_m ends_notmet i.education_level i.female i.partner_hh i.hh_comp, robust cluster(panelID)

*Males
stcox i.SPH neg_HShocks log_inc_m ends_notmet i.education_level i.partner_hh i.hh_comp if female == 0, robust cluster(panelID)

*Females
stcox i.SPH neg_HShocks log_inc_m ends_notmet i.education_level i.partner_hh i.hh_comp if female == 1, robust cluster(panelID)

*Test proportional hazards assumption for the Cox model
*estat phtest, detail

*Export results to Word (sample)
*esttab model1 model2 
*using "Cox_Models.docx", replace docx title("Cox Proportional Hazards Models") eform b(3) se(3) star(* 0.1 ** 0.05 *** 0.01)




