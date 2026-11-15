/* Project info
   1_build_data_261109.do | build the two country-year panels, then the two analysis files.
   Europe: 23 Eurostat countries, 2006-2019, N=295. OECD: 26 ILO countries, 2000-2024, N=477. Never pooled.
   Inputs: country_codes.csv, oecd_leave_history.xlsx, eurostat_employment_raw.csv,
   ilo_household_raw.csv, wdi_raw.dta, oecd_policy_donor.dta. */

//If log setting is activated, we record a log file in the log folder
if ${store_log_build}==1 {
    cap log close
    capture noisily log using "${log_dir}/1_build_data_261109.log", text replace
}

* Data sources; the copies used here are in data_raw
* Eurostat. 2026. "Adults by number of children, age of youngest child and
*   labour status" [lfst_hhacwnc] (dataset). DOI 10.2908/lfst_hhacwnc,
*   last update 10/09/2026 15:00. Luxembourg: European Commission, Eurostat.
*   https://ec.europa.eu/eurostat/databrowser/view/lfst_hhacwnc/default/table
*   (accessed 14 November 2026).
* OECD. 2026. "PF2.5 Trends in leave entitlements around childbirth" (dataset),
*   OECD Family Database, updated November 2026. Paris: OECD.
*   https://webfs.oecd.org/els-com/Family_Database/PF2_5_Trends_in_leave_entitlements_around_childbirth.xlsx
*   (accessed 14 November 2026).
* International Labour Organization. 2026. "Employment rate by sex and household
*   composition" [GED_PEPR_SEX_HHT_CHL_RT_A] (database), ILOSTAT. Geneva: ILO.
*   https://ilostat.ilo.org/data/ (accessed 14 November 2026).
* World Bank. 2026. World Development Indicators (dataset), NY.GDP.PCAP.KD and
*   NY.GDP.MKTP.KD.ZG, last updated 11 November 2026. Washington, DC: World Bank.
*   https://databank.worldbank.org/source/world-development-indicators
*   (accessed 14 November 2026).
* OECD. 2026. Social Expenditure Database (SOCX) (dataset), public maternity and
*   parental leave spending. Paris: OECD. https://doi.org/10.1787/data-00167-en
*   (accessed 14 November 2026).

* Build both panels from the raw source files
* Europe: Eurostat lfst_hhacwnc, 23 OECD countries, 2006-2019, N=295
* Import the original OECD policy workbook.
import delimited "${datadir_raw}/country_codes.csv", clear varnames(1)
tempfile country_codes euro_codes policy oecd_policy_lag
save `country_codes'
preserve
keep if geo!=""
save `euro_codes'
restore

import excel "${datadir_raw}/oecd_leave_history.xlsx", sheet("Time-Series") cellrange(A9) clear
rename A country
rename B year
rename S total_all_raw
rename T total_paid_raw
keep country year total_all_raw total_paid_raw
keep if inrange(year,1970,2024)
merge m:1 country using `country_codes'
keep if _merge==3
drop _merge
isid iso year
encode iso, generate(pid)
xtset pid year, yearly
sort pid year

* Correct the policy series to the legal effective years
generate timing_note = ""
replace total_paid_raw = "2.6" if iso=="FRA" & year==2014
replace timing_note = "PreParE effective 2015, not 2014" if iso=="FRA" & year==2014
replace total_paid_raw = "4" if iso=="IRL" & year==2019
replace timing_note = "Two weeks Parents Leave effective November 2019" if iso=="IRL" & year==2019
replace total_paid_raw = string(real(total_paid_raw)+13) if iso=="ITA" & year==2022
replace timing_note = "Three months reserved paid parental leave effective August 2022" if iso=="ITA" & year==2022

* Align annual snapshots to the legal years listed in the OECD annex.
foreach measure in all paid {
    generate snapshot = real(total_`measure'_raw)
    replace total_`measure'_raw = string(F1.snapshot,"%18.10g") if iso=="AUT" & year==2019
    replace total_`measure'_raw = string(F1.snapshot,"%18.10g") if iso=="EST" & year==2020
    replace total_`measure'_raw = string(F1.snapshot,"%18.10g") if iso=="FIN" & year==2010
    replace total_`measure'_raw = string(F1.snapshot,"%18.10g") if iso=="GRC" & year==2021
    drop snapshot
}
replace timing_note = "OECD annex: effective 2019; 2020 snapshot" if iso=="AUT" & year==2019
replace timing_note = "OECD annex: effective 2020; 2021 snapshot" if iso=="EST" & year==2020
replace timing_note = "OECD annex: effective 2010; 2011 snapshot" if iso=="FIN" & year==2010
replace timing_note = "OECD annex: effective 2021; 2022 snapshot" if iso=="GRC" & year==2021

* Retain slash-separated entitlement options instead of averaging them.
foreach measure in all paid {
    * Only two slash-separated values occur in the workbook; keep both options.
    generate `measure'_option1 = real(total_`measure'_raw)
    generate `measure'_option2 = .
    replace `measure'_option1 = 28.6  if total_`measure'_raw == "28.6 / 54.6"
    replace `measure'_option2 = 54.6  if total_`measure'_raw == "28.6 / 54.6"
    replace `measure'_option1 = 30.17 if total_`measure'_raw == "30.17 / 56.17"
    replace `measure'_option2 = 56.17 if total_`measure'_raw == "30.17 / 56.17"
    generate `measure'_min = `measure'_option1
    replace `measure'_min = `measure'_option2 if !missing(`measure'_option2) & (`measure'_option2 < `measure'_min | missing(`measure'_min))
    generate `measure'_max = `measure'_option1
    replace `measure'_max = `measure'_option2 if !missing(`measure'_option2) & (`measure'_option2 > `measure'_max | missing(`measure'_max))
    generate `measure'_n = !missing(`measure'_option1) + !missing(`measure'_option2)
    generate known_`measure' = `measure'_n>0 & `measure'_min>=0
    generate same_`measure' = `measure'_n==L1.`measure'_n & abs(`measure'_min-L1.`measure'_min)<=0.1 & abs(`measure'_max-L1.`measure'_max)<=0.1
    generate nondecrease_`measure' = same_`measure' | `measure'_min>=L1.`measure'_max-0.1
    generate increase_`measure' = `measure'_min>L1.`measure'_max+0.1
}
generate known_policy = known_all & known_paid
generate expansion = year==L1.year+1 & known_policy & L1.known_policy==1 & nondecrease_all & nondecrease_paid & (increase_all | increase_paid)
replace expansion = 0 if !inrange(year,2000,2024)
* Czech 2007 records a benefit change, not a verified new duration right.
replace expansion = 0 if iso=="CZE" & year==2007
generate reform_year = year if expansion==1
bysort iso: egen first_reform = min(reform_year)
replace reform_year = first_reform
drop first_reform

* Calculate the OECD leave lag on the annual policy history before merging employment.
preserve
sort pid year
generate policy_weeks10 = real(total_paid_raw)/10 if known_policy==1
replace policy_weeks10 = 2.86 if total_paid_raw=="28.6 / 54.6" & known_policy==1
replace policy_weeks10 = 3.017 if total_paid_raw=="30.17 / 56.17" & known_policy==1
generate policy_lag_weeks10 = L1.policy_weeks10
keep iso year policy_lag_weeks10
keep if inrange(year,2000,2024)
save `oecd_policy_lag'
restore

keep iso country year total_all_raw total_paid_raw known_policy reform_year timing_note
keep if inrange(year,2000,2024)
save `policy'

* Read the Eurostat employment file.
import delimited "${datadir_raw}/eurostat_employment_raw.csv", clear varnames(1)
rename time year
keep if freq=="A" & age=="Y25-54" & unit=="THS_PER"
keep if n_child=="TOTAL" & agechild=="Y_LT6"
keep if inlist(sex,"M","F") & inlist(wstatus,"EMP","POP")
merge m:1 geo using `euro_codes'
keep if _merge==3 & geo!=""
drop _merge
* Retain the established 23-country Eurostat sample, all OECD members.
keep if inrange(year,2006,2019)
bysort iso year: egen unreliable = max(strpos(flag,"u")>0)
keep if unreliable==0
generate measure = sex+"_"+wstatus
keep iso year measure value flag
isid iso year measure
reshape wide value flag, i(iso year) j(measure) string
generate male_rate = 100*valueM_EMP/valueM_POP
recast double male_rate
replace male_rate = 100*valueM_EMP/valueM_POP
generate female_rate = 100*valueF_EMP/valueF_POP
recast double female_rate
replace female_rate = 100*valueF_EMP/valueF_POP
generate source_flags = flagF_EMP+";"+flagF_POP+";"+flagM_EMP+";"+flagM_POP
keep iso year male_rate female_rate source_flags

* Unmatched rows are policy years outside the panel or countries outside the sample.
* Merge raw outcomes with the policy history and apply the sample rule below.
merge 1:1 iso year using `policy'
keep if _merge==3 & known_policy==1
drop _merge
drop if missing(male_rate,female_rate)
generate employment_gap = male_rate-female_rate
recast double employment_gap
replace employment_gap = male_rate-female_rate
generate treated = reform_year<=2019
encode iso, generate(country_id)
isid country_id year
sort country_id year
save "${datadir_final}/europe_twfe.dta", replace
export delimited using "${datadir_final}/europe_twfe.csv", replace

* OECD extension: ILO household series, 26 countries, 2000-2024, N=477

* Read the ILO household file.
import delimited "${datadir_raw}/ilo_household_raw.csv", clear varnames(1)
rename ref_area iso
rename time year
keep if classif1=="HHT_AGGREGATE_K" & classif2=="CHL_AGET6_YES"
keep if inlist(sex,"SEX_M","SEX_F") & inrange(year,2000,2024)
bysort iso year: egen flagged = max(obs_status!="")
keep if flagged==0
generate sexcode = "F"
replace sexcode = "M" if sex=="SEX_M"
keep iso year sexcode obs_value
isid iso year sexcode
reshape wide obs_value, i(iso year) j(sexcode) string
rename obs_valueM male_rate
rename obs_valueF female_rate
generate source_flags = ""

* Unmatched rows are policy years outside the panel or countries outside the sample.
* Merge raw outcomes with the policy history and apply the sample rule below.
merge 1:1 iso year using `policy'
keep if _merge==3 & known_policy==1
drop _merge
drop if missing(male_rate,female_rate)
generate employment_gap = male_rate-female_rate
recast double employment_gap
replace employment_gap = male_rate-female_rate
generate treated = reform_year<=2024
encode iso, generate(country_id)
isid country_id year
sort country_id year
save "${datadir_final}/oecd_twfe.dta", replace
export delimited using "${datadir_final}/oecd_twfe.csv", replace


* Build the GDP controls on the full annual series, before merging.
preserve
    use "${datadir_raw}/wdi_raw.dta", clear
    rename countrycode iso
    keep iso year ny_gdp_pcap_kd ny_gdp_mktp_kd_zg
    duplicates report iso year

    generate lngdp = ln(ny_gdp_pcap_kd) if ny_gdp_pcap_kd>0
    recast double lngdp
    replace lngdp = ln(ny_gdp_pcap_kd) if ny_gdp_pcap_kd>0

    generate gdp_growth = ny_gdp_mktp_kd_zg
    recast double gdp_growth
    replace gdp_growth = ny_gdp_mktp_kd_zg

    encode iso, generate(wdi_id)
    xtset wdi_id year, yearly

    generate lag_lngdp = L1.lngdp
    recast double lag_lngdp
    replace lag_lngdp = L1.lngdp

    generate lag_gdp_growth = L1.gdp_growth
    recast double lag_gdp_growth
    replace lag_gdp_growth = L1.gdp_growth

    label variable lngdp "Log real GDP per capita (WDI, constant prices)"
    label variable gdp_growth "Real GDP growth, percent (WDI)"
    label variable lag_lngdp "Lagged log real GDP per capita"
    label variable lag_gdp_growth "Lagged real GDP growth, percent"
    keep iso year ny_gdp_pcap_kd ny_gdp_mktp_kd_zg lngdp gdp_growth lag_lngdp lag_gdp_growth
    save "${datadir_final}/wdi_controls.dta", replace
restore

preserve
    use "${datadir_raw}/oecd_policy_donor.dta", clear
    keep countrycode year leave_gdp maternal_weeks
    rename countrycode iso
    duplicates report iso year
    save "${datadir_final}/policy_controls.dta", replace
restore

* Build one analysis file per sample
foreach s in europe oecd {

    use "${datadir_final}/`s'_twfe.dta", clear
    xtset country_id year, yearly

    * PF2.1 Total_Father_specific_paid; slash cells keep the lower bound
    generate fatherweeks = real(total_paid_raw)
    recast double fatherweeks
    replace fatherweeks = real(total_paid_raw)
    replace fatherweeks = 28.6  if total_paid_raw == "28.6 / 54.6"
    replace fatherweeks = 30.17 if total_paid_raw == "30.17 / 56.17"
    label variable fatherweeks "Weeks of paid father-specific leave (PF2.1, lower bound)"

    * Unit: pp change in the gap per 10 extra weeks of lagged leave
    generate fatherweeks10 = fatherweeks/10
    label variable fatherweeks10 "Father-specific paid leave, per 10 weeks"
    if "`s'" == "oecd" {
        * Keep employment rows and attach the policy lag, including across employment gaps.
        merge 1:1 iso year using `oecd_policy_lag'
        drop if _merge==2
        drop _merge
        generate lag_fatherweeks10 = policy_lag_weeks10
        drop policy_lag_weeks10
    }
    else {
        generate lag_fatherweeks10 = L1.fatherweeks10
    }
    label variable lag_fatherweeks10 "Lagged father-specific paid leave, per 10 weeks"

    * WDI macro controls, with lags already built on the full annual series
    sort iso year
    merge 1:1 iso year using "${datadir_final}/wdi_controls.dta"
    keep if _merge==3
    drop _merge

    * Public leave spending; maternal_weeks kept for inspection only (sparse coverage)
    sort iso year
    merge 1:1 iso year using "${datadir_final}/policy_controls.dta"
    keep if _merge==3
    drop _merge

    * Lagged log GDP per capita is required in every regression
    label variable leave_gdp "Public maternity and parental leave spending, percent of GDP"

    * post: years at/after the first verified expansion; controls have no reform year
    generate post = (year>=reform_year) if !missing(reform_year)
    replace post = 0 if missing(post)
    label variable post "Post first verified expansion of reserved paid leave"

    * Coverage of the control variables
    * Non-missing paid maternity weeks
    count if maternal_weeks!=.
    * Non-missing lagged log GDP per capita
    count if lag_lngdp!=.
    * Non-missing public leave spending
    count if leave_gdp!=.

    save "${datadir_final}/`s'_analysis_261109.dta", replace
}

* CSV copies of the analysis files
foreach s in europe oecd {
    use "${datadir_final}/`s'_analysis_261109.dta", clear
    export delimited using "${datadir_final}/`s'_analysis_261109.csv", replace
}

* Leave the primary sample in memory for the next do-file.
use "${datadir_final}/europe_analysis_261109.dta", clear

//Close log if needed
if ${store_log_build}==1 {
    cap log close
}
