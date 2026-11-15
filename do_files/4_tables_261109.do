/* Project info
   4_tables_261109.do | non-linearity and winsorized checks, build-up and subset tables. */

//If log setting is activated, we record a log file in the log folder
if ${store_log_tables}==1 {
    cap log close
    capture noisily log using "${log_dir}/4_tables_261109.log", text replace
}

* Quadratic specification, European panel
use "${datadir_final}/europe_analysis_261109.dta", clear
xtset country_id year, yearly

xtpcse employment_gap c.lag_fatherweeks10##c.lag_fatherweeks10 ///
    ${controls} i.year i.country_id, het corr(ar1)
estimates store pcse_quad
* The quadratic term does not improve the fit, so the linear specification is kept.

* Winsorize every continuous variable at the 1/99 percentiles and count the changes
summarize employment_gap, detail
local p1_gap = r(p1)
local p99_gap = r(p99)
generate employment_gap_winsor = employment_gap
recast double employment_gap_winsor
replace employment_gap_winsor = employment_gap
label variable employment_gap_winsor "Employment gap, winsorized 1/99 (pp)"
replace employment_gap_winsor = `p1_gap' if employment_gap_winsor < `p1_gap' & employment_gap_winsor != .
replace employment_gap_winsor = `p99_gap' if employment_gap_winsor > `p99_gap' & employment_gap_winsor != .
count if employment_gap_winsor != employment_gap & employment_gap != .
display "Observations changed by outcome winsorization = " r(N)

summarize lag_fatherweeks10, detail
local p1_leave = r(p1)
local p99_leave = r(p99)
generate lag_fatherweeks10_winsor = lag_fatherweeks10
recast double lag_fatherweeks10_winsor
replace lag_fatherweeks10_winsor = lag_fatherweeks10
label variable lag_fatherweeks10_winsor "Lagged father-specific paid leave, winsorized 1/99"
replace lag_fatherweeks10_winsor = `p1_leave' if lag_fatherweeks10_winsor < `p1_leave' & lag_fatherweeks10_winsor != .
replace lag_fatherweeks10_winsor = `p99_leave' if lag_fatherweeks10_winsor > `p99_leave' & lag_fatherweeks10_winsor != .
count if lag_fatherweeks10_winsor != lag_fatherweeks10 & lag_fatherweeks10 != .
display "Observations changed by leave weeks winsorization = " r(N)

summarize lag_lngdp, detail
local p1_gdp = r(p1)
local p99_gdp = r(p99)
generate lag_lngdp_winsor = lag_lngdp
recast double lag_lngdp_winsor
replace lag_lngdp_winsor = lag_lngdp
label variable lag_lngdp_winsor "Lagged log real GDP per capita, winsorized 1/99"
replace lag_lngdp_winsor = `p1_gdp' if lag_lngdp_winsor < `p1_gdp' & lag_lngdp_winsor != .
replace lag_lngdp_winsor = `p99_gdp' if lag_lngdp_winsor > `p99_gdp' & lag_lngdp_winsor != .
count if lag_lngdp_winsor != lag_lngdp & lag_lngdp != .
display "Observations changed by log GDP winsorization = " r(N)

summarize lag_gdp_growth, detail
local p1_growth = r(p1)
local p99_growth = r(p99)
generate lag_gdp_growth_winsor = lag_gdp_growth
recast double lag_gdp_growth_winsor
replace lag_gdp_growth_winsor = lag_gdp_growth
label variable lag_gdp_growth_winsor "Lagged real GDP growth, winsorized 1/99"
replace lag_gdp_growth_winsor = `p1_growth' if lag_gdp_growth_winsor < `p1_growth' & lag_gdp_growth_winsor != .
replace lag_gdp_growth_winsor = `p99_growth' if lag_gdp_growth_winsor > `p99_growth' & lag_gdp_growth_winsor != .
count if lag_gdp_growth_winsor != lag_gdp_growth & lag_gdp_growth != .
display "Observations changed by GDP growth winsorization = " r(N)

summarize leave_gdp, detail
local p1_spend = r(p1)
local p99_spend = r(p99)
generate leave_gdp_winsor = leave_gdp
recast double leave_gdp_winsor
replace leave_gdp_winsor = leave_gdp
label variable leave_gdp_winsor "Public leave spending, winsorized 1/99 (percent of GDP)"
replace leave_gdp_winsor = `p1_spend' if leave_gdp_winsor < `p1_spend' & leave_gdp_winsor != .
replace leave_gdp_winsor = `p99_spend' if leave_gdp_winsor > `p99_spend' & leave_gdp_winsor != .
count if leave_gdp_winsor != leave_gdp & leave_gdp != .
display "Observations changed by leave spending winsorization = " r(N)

* Repeat the preferred specification with all continuous variables winsorized
xtpcse employment_gap_winsor lag_fatherweeks10_winsor lag_lngdp_winsor ///
    lag_gdp_growth_winsor leave_gdp_winsor i.year i.country_id, het corr(ar1)
estimates store pcse_winsor
* The unwinsorized specification is preferred; winsorization keeps the same sign and significance.

etable, estimates(pcse_quad pcse_winsor) ///
    keep(lag_fatherweeks10 c.lag_fatherweeks10#c.lag_fatherweeks10 ///
         lag_fatherweeks10_winsor lag_lngdp lag_lngdp_winsor ///
         lag_gdp_growth lag_gdp_growth_winsor leave_gdp leave_gdp_winsor) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_europe_robust_261109.docx", replace)

* Single specification built one variable at a time, OECD full sample
use "${datadir_final}/oecd_analysis_261109.dta", clear
xtset country_id year, yearly

* Keep one estimation sample in all four columns
generate byte same_sample = 1
replace same_sample = 0 if missing(employment_gap)
replace same_sample = 0 if missing(lag_fatherweeks10)
replace same_sample = 0 if missing(lag_lngdp)
replace same_sample = 0 if missing(lag_gdp_growth)
replace same_sample = 0 if missing(leave_gdp)
count if same_sample==1

xtpcse employment_gap lag_fatherweeks10 i.year i.country_id ///
    if same_sample==1, het corr(ar1)
estimates store build1
xtpcse employment_gap lag_fatherweeks10 lag_lngdp i.year i.country_id ///
    if same_sample==1, het corr(ar1)
estimates store build2
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year i.country_id if same_sample==1, het corr(ar1)
estimates store build3
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year i.country_id if same_sample==1, het corr(ar1)
estimates store build4

etable, estimates(build1 build2 build3 build4) ///
    keep(lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(index) ///
    note("Year FE: yes; Country FE: yes in all columns. Main regressor enters first; no non-linear term is added. All four columns use the same observations with complete data on every variable.") ///
    export("${tabledir}/results_buildup_261109.docx", replace)

* Subsets compare countries with and without supranational EU leave mandates
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year i.country_id, het corr(ar1)
estimates store all_countries
generate byte european = 0
replace european = 1 if inlist(iso,"AUT","BEL","CZE","DEU","ESP","EST","FRA","GBR")
replace european = 1 if inlist(iso,"GRC","HUN","IRL","ITA","LTU","LUX","LVA","NLD")
replace european = 1 if inlist(iso,"POL","PRT","SVN")
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year i.country_id if european==1, het corr(ar1)
estimates store sub_europe
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth ///
    i.year i.country_id if european==0, het corr(ar1)
estimates store sub_noneurope

etable, estimates(all_countries sub_europe sub_noneurope) ///
    keep(lag_fatherweeks10 lag_lngdp lag_gdp_growth) ///
    mstat(N) mstat(r2) showstars showstarsnote varlabel column(index) ///
    note("Year FE: yes; Country FE: yes. Subsets split the 26 OECD members by supranational EU leave mandates (19 European, 7 non-European). Use the non-European column for the geographic comparison.") ///
    export("${tabledir}/results_subsets_261109.docx", replace)

//Close log if needed
if ${store_log_tables}==1 {
    cap log close
}
