/* Project info
   1_build_data_261109.do | build the OECD childcare panel from the raw sources
   output oecd_childcare_261109.dta, OECD countries seen from 2000 to 2024
   inputs were country_codes.csv, ilo_household_raw.csv, oecd_socx_ecec_gdp.csv,
   oecd_socx_tp512_leave.csv, oecd_leave_timeseries.csv and wdi_raw.dta */

//If log setting is activated, we record a log file in the log folder
if ${store_log_build}==1 {
    capture log close
    capture noisily log using "${log_dir}/1_build_data_261109.log", text replace
}

* Data sources, the copies we actually read sit in data_raw
* International Labour Organization. 2026. "Employment rate by sex and household
*   composition" [GED_PEPR_SEX_HHT_CHL_RT_A] (database), ILOSTAT. Geneva: ILO.
*   https://ilostat.ilo.org/data/ (accessed 14 November 2026).
* OECD. 2026. Social Expenditure Database (SOCX) (dataset), public spending on
*   early childhood education and care (TP521) and on maternity and parental
*   leave (TP512), percent of GDP. Paris: OECD. https://doi.org/10.1787/data-00167-en
*   (accessed 16 November 2026).
* OECD. 2026. "PF2.5 Trends in leave entitlements around childbirth" (dataset),
*   OECD Family Database, updated November 2026. Paris: OECD.
*   https://webfs.oecd.org/els-com/Family_Database/PF2_5_Trends_in_leave_entitlements_around_childbirth.xlsx
*   (accessed 14 November 2026).
* World Bank. 2026. World Development Indicators (dataset), NY.GDP.PCAP.KD,
*   last updated 11 November 2026. Washington, DC: World Bank.
*   https://databank.worldbank.org/source/world-development-indicators
*   (accessed 14 November 2026).

* country names and ISO codes, used to match the sources
import delimited "${datadir_raw}/country_codes.csv", clear varnames(1)

save "${datadir_final}/tmp_country_codes.dta", replace

* control variables, weeks of paid leave kept for fathers and mothers, from the OECD workbook
import delimited "${datadir_raw}/oecd_leave_timeseries.csv", clear varnames(1)
keep country year total_paid_raw total_paid_mothers_raw
keep if inrange(year,1970,2024)
* unmatched rows are workbook notes and countries not on the OECD list
merge m:1 country using "${datadir_final}/tmp_country_codes.dta"
keep if _merge==3
drop _merge

sort iso year
encode iso, generate(leave_id)
xtset leave_id year, yearly
sort leave_id year

* parse the leave weeks out of their text columns
* two paid entries give two options with a slash, we took the lower one
generate fatherweeks = real(total_paid_raw)
replace fatherweeks = 28.6  if total_paid_raw == "28.6 / 54.6"
replace fatherweeks = 30.17 if total_paid_raw == "30.17 / 56.17"

* France reports a short and a long option for mothers, we took the short one
generate motherweeks = real(total_paid_mothers_raw)
replace motherweeks = 16 if total_paid_mothers_raw == "16.0 / 162.0"
replace motherweeks = 42 if total_paid_mothers_raw == "42.0 / 162.0"
replace motherweeks = 42 if total_paid_mothers_raw == "42.0 / 136.0"
replace motherweeks = 42 if total_paid_mothers_raw == "42.0 / 110"

* three entries moved to the year the leave became law
replace fatherweeks = 2.6 if iso=="FRA" & year==2014
replace fatherweeks = 4 if iso=="IRL" & year==2019
replace fatherweeks = 15 if iso=="ITA" & year==2022

* four snapshots logged a reform one year late, so we used next year's value
replace fatherweeks = 12.996666 if iso=="AUT" & year==2019
replace fatherweeks = 4.285714286 if iso=="EST" & year==2020
replace fatherweeks = 9 if iso=="FIN" & year==2010
replace fatherweeks = 11.46666 if iso=="GRC" & year==2021
label variable fatherweeks "Weeks of paid father-specific leave (lower bound)"
label variable motherweeks "Weeks of paid maternity, parental and home care leave for mothers"

* build the lag on the full 2000-2024 series, before the merge
keep if inrange(year,2000,2024)
drop leave_id
encode iso, generate(leave_id)
xtset leave_id year, yearly
generate fatherweeks10 = fatherweeks/10
generate lag_fatherweeks10 = L1.fatherweeks10
generate motherweeks10 = motherweeks/10
generate lag_motherweeks10 = L1.motherweeks10
label variable fatherweeks10 "Father-specific paid leave, per 10 weeks"
label variable lag_fatherweeks10 "Lagged father-specific paid leave, per 10 weeks"
label variable motherweeks10 "Mother-side paid leave, per 10 weeks"
label variable lag_motherweeks10 "Lagged mother-side paid leave, per 10 weeks"
keep iso country year fatherweeks fatherweeks10 lag_fatherweeks10 motherweeks motherweeks10 lag_motherweeks10
save "${datadir_final}/tmp_leave_weeks.dta", replace

* control variable, GDP per capita, lagged on the full series
use "${datadir_raw}/wdi_raw.dta", clear
rename countrycode iso
keep iso year ny_gdp_pcap_kd
generate lngdp = ln(ny_gdp_pcap_kd) if ny_gdp_pcap_kd>0
encode iso, generate(gdp_id)
xtset gdp_id year, yearly
generate lag_lngdp = L1.lngdp
label variable lag_lngdp "Lagged log real GDP per capita"
keep iso year lngdp lag_lngdp
save "${datadir_final}/tmp_gdp_controls.dta", replace

* control variable, public spending on maternity and parental leave
import delimited using "${datadir_raw}/oecd_socx_tp512_leave.csv", clear varnames(1)
keep if unit_measure=="PT_B1GQ" & expend_source=="ES10" & programme_type=="TP512"
rename ref_area iso
rename time_period year
keep iso year obs_value
rename obs_value leave_gdp
label variable leave_gdp "Public maternity and parental leave spending, percent of GDP"
save "${datadir_final}/tmp_leave_spending.dta", replace

* main explanatory variable, childcare spending lagged on the full series
import delimited using "${datadir_raw}/oecd_socx_ecec_gdp.csv", clear varnames(1)
keep if unit_measure=="PT_B1GQ" & expend_source=="ES10" & programme_type=="TP521"
rename ref_area iso
rename time_period year
keep iso year obs_value
encode iso, generate(spending_id)
xtset spending_id year, yearly
sort spending_id year
generate lag_socx_ecec = L1.obs_value
label variable lag_socx_ecec "Prior-year public ECEC spending (% of GDP)"
keep iso year lag_socx_ecec

sort iso year
save "${datadir_final}/tmp_childcare_spending.dta", replace

* dependent variable, employment rates of mothers and fathers of children under six
import delimited "${datadir_raw}/ilo_household_raw.csv", clear varnames(1)
rename ref_area iso
rename time year
keep if classif1=="HHT_AGGREGATE_K" & classif2=="CHL_AGET6_YES"
keep if inlist(sex,"SEX_M","SEX_F") & inrange(year,2000,2024)
* drop country-years that ILOSTAT marks as unreliable
bysort iso year: egen flagged = max(obs_status!="")
keep if flagged==0
generate sexcode = "F"
replace sexcode = "M" if sex=="SEX_M"
keep iso year sexcode obs_value
duplicates report iso year sexcode

sort iso year sexcode
reshape wide obs_value, i(iso year) j(sexcode) string
rename obs_valueM male_rate
rename obs_valueF female_rate
label variable male_rate "Fathers' employment rate, percent"
label variable female_rate "Mothers' employment rate, percent"

* merge the paid-leave weeks controls
* matched rows without a father leave record drop, they carry no entitlement to lag
merge 1:1 iso year using "${datadir_final}/tmp_leave_weeks.dta"
keep if _merge==3 & !missing(fatherweeks)
drop _merge
drop if missing(male_rate,female_rate)
generate employment_gap = male_rate-female_rate
label variable employment_gap "Male minus female employment rate (pp)"
encode iso, generate(country_id)

sort country_id year

* merge the GDP controls, unmatched rows sit outside the panel
merge 1:1 iso year using "${datadir_final}/tmp_gdp_controls.dta"
keep if _merge==3
drop _merge

* merge leave spending
* unmatched country-years have no SOCX row, 2024 and a few others, they stay missing
merge 1:1 iso year using "${datadir_final}/tmp_leave_spending.dta"
drop if _merge==2
drop _merge

* merge childcare spending
* spending-only rows are outside the job panel, job rows with no spending stay and get marked
merge 1:1 iso year using "${datadir_final}/tmp_childcare_spending.dta"
tabulate _merge
drop if _merge==2
drop _merge

* two subsets, European countries under the EU childcare targets and the rest of the OECD
generate byte eu_childcare = 0
replace eu_childcare = 1 if inlist(iso,"AUT","BEL","CZE","DEU","ESP","EST","FRA","GBR")
replace eu_childcare = 1 if inlist(iso,"GRC","HUN","IRL","ITA","LTU","LUX","LVA","NLD")
replace eu_childcare = 1 if inlist(iso,"POL","PRT","SVN")
label variable eu_childcare "European group covered by EU childcare targets during the study period"

* flag country-years where every model variable is there
generate byte childcare_sample = 1
replace childcare_sample = 0 if missing(employment_gap, lag_socx_ecec, lag_fatherweeks10, lag_motherweeks10)
replace childcare_sample = 0 if missing(lag_lngdp, leave_gdp)
label variable childcare_sample "Complete-case sample for the childcare regressions"
tabulate childcare_sample

* log versions of the continuous variables, for the elasticity model
generate ln_gap = ln(employment_gap)
generate ln_childcare = ln(1 + lag_socx_ecec)
generate ln_fatherleave = ln(1 + lag_fatherweeks10)
generate ln_motherweeks = ln(1 + lag_motherweeks10)
generate ln_leavespending = ln(leave_gdp)
label variable ln_gap "Log of the male minus female employment gap"
label variable ln_childcare "Log of one plus prior-year ECEC spending (% of GDP)"
label variable ln_fatherleave "Log of one plus lagged father leave (per 10 weeks)"
label variable ln_motherweeks "Log of one plus lagged mother-side paid leave (per 10 weeks)"
label variable ln_leavespending "Log of public leave spending (% of GDP)"

xtset country_id year, yearly
save "${datadir_final}/oecd_childcare_261109.dta", replace
export delimited using "${datadir_final}/oecd_childcare_261109.csv", replace

//Close log if needed
if ${store_log_build}==1 {
    capture log close
}
