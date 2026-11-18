/* Project info
   4_tables_261109.do | the build-up table and the winsorizing check */
if ${store_log_tables}==1 {
    capture log close
    capture noisily log using "${log_dir}/4_tables_261109.log", text replace
}

use "${datadir_final}/oecd_childcare_261109.dta", clear
keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly

* hold the sample and all effects fixed across the columns
xtpcse ln_gap ln_childcare ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build1
xtpcse ln_gap ln_childcare ln_fatherleave ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build2
xtpcse ln_gap ln_childcare ln_fatherleave ln_motherweeks ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build3
xtpcse ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build4
xtpcse ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store build5

* country, year and trend effects in every column, same sample throughout
etable, estimates(build1 build2 build3 build4 build5) ///
    keep(ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_childcare_buildup_261109.docx", replace)

* winsorize the six continuous variables on the main sample
foreach var in ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending {
    quietly summarize `var', detail
    local low = r(p1)
    local high = r(p99)
    generate w_`var' = `var'
    replace w_`var' = `low' if `var'<`low'
    replace w_`var' = `high' if `var'>`high'
}

xtpcse w_ln_gap w_ln_childcare w_ln_fatherleave w_ln_motherweeks w_lag_lngdp ///
    w_ln_leavespending i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_winsor
testparm w_ln_childcare
* keep the observed spending as the preferred spec, winsorizing changes little

* column 1 uses the raw numbers, column 2 winsorizes each continuous variable at 1 and 99
etable, estimates(build5 childcare_winsor) ///
    keep(ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
         w_ln_childcare w_ln_fatherleave w_ln_motherweeks w_lag_lngdp w_ln_leavespending) ///
    mstat(N) showstars showstarsnote column(dvlabel) ///
    export("${tabledir}/results_childcare_winsor_261109.docx", replace)

if ${store_log_tables}==1 {
    capture log close
}
