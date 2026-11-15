/* OECD extension | country-specific linear time trends.
   Run from the project root after 0_master_261109.do builds the annual panel. */

use "data_final/oecd_analysis_261109.dta", clear
xtset country_id year, yearly

* Estimate the one-year leave lag allowing a separate trend for each country.
xtpcse employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year i.country_id c.year#i.country_id, het corr(ar1)
test lag_fatherweeks10 = 0

* Estimate the same specification with country-clustered standard errors.
xtreg employment_gap lag_fatherweeks10 lag_lngdp lag_gdp_growth leave_gdp ///
    i.year c.year#i.country_id, fe vce(robust)
test lag_fatherweeks10 = 0
