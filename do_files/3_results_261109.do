/* Project info
   3_results_261109.do | the main OECD childcare expenditure regressions */

if ${store_log_mainresults}==1 {
    capture log close
    capture noisily log using "${log_dir}/3_results_261109.log", text replace
}

use "${datadir_final}/oecd_childcare_261109.dta", clear
keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly

* check year effects, heteroskedasticity and serial correlation
xtreg ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
    i.year c.year_centered#i.country_id, fe
testparm i.year
xttest3
xtserial ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending

* PCSE inference with first-order serial correlation
xtpcse ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_pcse
testparm ln_childcare

* a version without the country trends, but with both fixed effects
xtpcse ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
    i.year i.country_id, het corr(ar1)
estimates store childcare_no_trends
testparm ln_childcare

* level version kept as a comparison column on the same sample
xtpcse employment_gap lag_socx_ecec lag_fatherweeks10 lag_motherweeks10 lag_lngdp leave_gdp ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_level
testparm lag_socx_ecec

etable, estimates(childcare_pcse childcare_no_trends childcare_level) ///
    keep(ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
         lag_socx_ecec lag_fatherweeks10 lag_motherweeks10 leave_gdp) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_oecd_childcare_261109.docx", replace)

* check for curvature on the same sample
xtpcse ln_gap c.ln_childcare##c.ln_childcare ///
    ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
testparm c.ln_childcare#c.ln_childcare

if ${store_log_mainresults}==1 {
    capture log close
}
