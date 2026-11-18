/* Project info
   2_descriptive_261109.do | descriptives, figures and the subset runs */
if ${store_log_descriptive}==1 {
    capture log close
    capture noisily log using "${log_dir}/2_descriptive_261109.log", text replace
}

use "${datadir_final}/oecd_childcare_261109.dta", clear

* mean, sd, min, max and N for every model variable, 2019 only
preserve
    keep if year==2019 & !missing(ln_childcare)
    collapse ///
        (mean) mean_gap=ln_gap (sd) sd_gap=ln_gap ///
        (min) min_gap=ln_gap (max) max_gap=ln_gap ///
        (count) n_gap=ln_gap ///
        (mean) mean_childcare=ln_childcare (sd) sd_childcare=ln_childcare ///
        (min) min_childcare=ln_childcare (max) max_childcare=ln_childcare ///
        (count) n_childcare=ln_childcare ///
        (mean) mean_fatherleave=ln_fatherleave (sd) sd_fatherleave=ln_fatherleave ///
        (min) min_fatherleave=ln_fatherleave (max) max_fatherleave=ln_fatherleave ///
        (count) n_fatherleave=ln_fatherleave ///
        (mean) mean_lngdp=lag_lngdp (sd) sd_lngdp=lag_lngdp ///
        (min) min_lngdp=lag_lngdp (max) max_lngdp=lag_lngdp ///
        (count) n_lngdp=lag_lngdp ///
        (mean) mean_mleave=ln_leavespending (sd) sd_mleave=ln_leavespending ///
        (min) min_mleave=ln_leavespending (max) max_mleave=ln_leavespending ///
        (count) n_mleave=ln_leavespending ///
        (mean) mean_mother=ln_motherweeks (sd) sd_mother=ln_motherweeks ///
        (min) min_mother=ln_motherweeks (max) max_mother=ln_motherweeks ///
        (count) n_mother=ln_motherweeks
    list
    export excel using "${tabledir}/descriptive_2019_oecd_childcare_261109.xlsx", replace
    export delimited using "${tabledir}/descriptive_2019_oecd_childcare_261109.csv", replace
restore

keep if childcare_sample==1
generate year_centered = year - 2010
xtset country_id year, yearly
tabulate eu_childcare

* scatter of spending against the gap
twoway (scatter ln_gap ln_childcare) (lfit ln_gap ln_childcare), ///
    title("Public childcare spending and the employment gap") ///
    xtitle("Log of one plus prior-year ECEC spending (% of GDP)") ///
    ytitle("Log of the male minus female employment rate") ///
    legend(label(1 "Country-year observation") label(2 "Linear fit")) ///
    graphregion(color(white))
graph export "${figdir}/scatter_gap_childcare_261109.png", as(png) replace

* logged spending by the two groups used in the subsets
twoway (histogram ln_childcare if eu_childcare==1, color(navy) lcolor(black)) ///
    (histogram ln_childcare if eu_childcare==0, color(maroon) lcolor(black)), ///
    title("Public childcare spending by subgroup") ///
    xtitle("Log of one plus prior-year ECEC spending (% of GDP)") ///
    ytitle("Density") ///
    legend(label(1 "EU-target group") label(2 "Other OECD")) graphregion(color(white))
graph export "${figdir}/histogram_childcare_byregion_261109.png", as(png) replace

* same specification in each group and in the full sample
* the EU Barcelona targets tied childcare access to parental work
* https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022H1220(01)
xtpcse ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id, het corr(ar1)
estimates store childcare_all
xtpcse ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id if eu_childcare==1, het corr(ar1)
estimates store childcare_eu
xtpcse ln_gap ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending ///
    i.year i.country_id c.year_centered#i.country_id if eu_childcare==0, het corr(ar1)
estimates store childcare_other

* columns, all countries, EU group, other OECD, with country, year and trend effects in each
etable, estimates(childcare_all childcare_eu childcare_other) ///
    keep(ln_childcare ln_fatherleave ln_motherweeks lag_lngdp ln_leavespending) ///
    mstat(N) showstars showstarsnote varlabel column(dvlabel) ///
    export("${tabledir}/results_childcare_subsets_261109.docx", replace)

if ${store_log_descriptive}==1 {
    capture log close
}
