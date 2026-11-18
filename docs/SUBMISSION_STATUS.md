# 18 Nov submission notes — OECD childcare chain

Last updated 17 November 2026. This is the actionable checklist. Code work is
finished and verified; everything left is a manual team action.

## 1. Done and verified

- Five numbered do-files, four numbered logs, six tables (four Word tables
  plus the 2019 summary as `.csv` and `.xlsx`), two PNG figures, eleven
  `data_raw` inputs, seven `data_final` outputs.
- Full rerun from `data_raw` on 17 Nov: no `r()` errors anywhere. Logs are
  606 / 451 / 659 / 808 lines, roughly 12.6 / 9.4 / 13.7 / 16.8 pages with
  80-character wrapping — all under the 35-page limit the instructor
  confirmed on 16 November 2026.
- All four data sources cited in the do-file citation block
  (see `docs/DATA_CITATIONS.md`).
- 2019 single-year summary table, restricted to rows with the main regressor
  observed (23 rows; `leave_gdp` has 20), exported as `.csv` and `.xlsx`.
- Five-column build-up table with every column on the same 347-observation
  estimation sample: `tables/results_childcare_buildup_261109.docx`.
- Three-column subset table (all countries 347 / EU-target group 309 / other
  OECD 38): `tables/results_childcare_subsets_261109.docx`.
- Full 1/99 winsorized repeat of all six continuous model variables; the main
  coefficient is −0.479 with the same sign and significance:
  `tables/results_childcare_winsor_261109.docx`.
- Overlapping two-subset histogram of the main regressor:
  `figures/histogram_childcare_byregion_261109.png`; scatter with linear fit:
  `figures/scatter_gap_childcare_261109.png`.
- Year effects are tested by `testparm i.year` (p = 0.1342). The
  `xtreg, fe` country-effects F test is F(22,276) = 56.83, p < 0.001.
- Comments in the do-files about unmatched merges, the preferred
  unwinsorized specification, and why the non-linear term is not used.
- `testparm ln_childcare` prints childcare p-values for the log models, and
  `testparm lag_socx_ecec` does so for the level model, and the PCSE column prints chi2(1) = 12.17,
  p = 0.0005.

## 2. Manual actions still required

| # | Action | Owner | Why |
|---|---|---|---|
| 1 | Confirm the nine directories are synced in the OneDrive client | Hansen | Canvas submission comes from OneDrive, not GitHub |
| 2 | Upload to Canvas: 5 `.do`, 4 `.log`, `.csv` copies from `data_raw/` and `data_final/`, the table files, and 2 `.png` figures | Team | Canvas accepts only `log, csv, png, do, docx, jpeg`; try the `.xlsx` summary table first and fall back to its `.csv` if rejected |
| 3 | Paste the Canvas comments in §3 below | Team | 5 pts for stating whether results support the hypothesis; part of the 8 merge points |
| 4 | Check the four Word tables before submission and repeat the manual formatting | Sultana | The 17 Nov mother-leave control changed every coefficient, so the tables were re-exported with the raw Stata output. The earlier formatted versions carried outdated numbers and were replaced; column headings, SE notes, and FE and trend rows need formatting again |
| 5 | Open each numbered log in Word with the final font and margins and confirm the printed page count | Team | The page estimates above are conservative calculations, not a rendering |
| 6 | Check whether the Canvas assignment page has an extra upload field or naming rule, and confirm the live due date | Team | The exported PDF header says "Due No Due Date" and its body says "March 23rd"; Course Outline p.14 says 18 Nov |
| 7 | Fill `literature/` with the article PDFs and `paper/` with the draft | Sultana | Both folders are still empty; 11 Dec paper needs ≥8 peer-reviewed economics articles |
| 8 | Confirm 2 Dec and 7 Dec poster requirements; 11 Dec final paper deadline | Team | `ECON 490 Course Outline.pdf` p.14 |

## 3. Ready-to-paste Canvas comments (English)

> The primary PCSE AR(1) model finds a negative association between prior-year
> public childcare spending and the employment gap, conditional on country and
> year fixed effects, country-specific linear trends, and the existing controls,
> which now include lagged paid leave weeks for fathers and for mothers.
> The input employment panel contains 477 observations within 2000–2024. The
> regressions use 347 complete observations from 23 OECD countries over 2001–2023.
> The childcare coefficient is -0.472 (SE 0.135, p = 0.0005), and the full 1/99
> winsorized repeat gives -0.479 (SE 0.133, p < 0.001). Both use
> `xtpcse ..., het corr(ar1)`, following Test7. Both leave-week controls are
> individually insignificant, so the association is specific to childcare
> spending rather than to paid leave in general.
>
> The result depends on country-specific trends. Removing only the trends
> while retaining both fixed effects gives +0.090 (p = 0.5488). We report a
> conditional association under the stated specification, with no causal claim.
>
> Childcare is ln(1+x), with x measured in percent of GDP. The local spending
> elasticity is beta*x/(1+x), approximately -0.17 at the sample mean of 0.538.
> Thus a 1 percent relative spending increase is associated with about a 0.17
> percent smaller gap at that value. Lagged log real GDP per capita is the only GDP control. GDP growth is excluded.
>
> Merge note: all merges are performed inside `1_build_data_261109.do`. Two
> distinct kinds of observation loss occur and neither is an error. (i) Rows
> that do not match: the OECD SOCX spending series contains 582 country-years
> outside the employment panel (spending history for countries and years the
> ILOSTAT outcome series does not cover), and 50 employment-panel country-years
> have no SOCX spending record; both groups are excluded after harmonising
> country codes, and the merge output printed in the log shows the split
> (427 matched, 50 master-only, 582 using-only). (ii) Rows that do match but
> still leave the regression: requiring a numeric lagged spending value, the
> outcome, and all controls (lagged father-specific leave weeks, lagged log
> GDP per capita, and public maternity and parental leave
> spending) reduces the panel from 477 to the 347 complete cases marked by
> `childcare_sample`. Every lag in the build is computed on its own full
> annual series before any merge, so a country-year is never lost merely
> because the previous year's employment observation is missing.
>
> Subset note: the three-column subset table splits the sample into the EU
> countries covered by the EU childcare targets (the Barcelona targets and the
> 2022 Council Recommendation on early childhood education and care) and the
> other OECD members, because a supranational ECEC commitment exists only on
> the EU side. The EU column has 309 observations and the other-OECD column
> 38; the smaller column is shown for the required comparison only and its
> coefficient must not be read as a policy effect.
>
> Diagnostics: `xttest3` rejects groupwise homoskedasticity (p < 0.001), and
> `xtserial` reports serial correlation (p = 0.0006). We use panel-specific
> heteroskedasticity and common AR(1) in PCSE. These are assumed error structures,
> and the diagnostic auxiliary regression does not establish that every feature
> of the final model is correctly specified. The year-effects test has
> p = 0.1312 and the country-effects F test printed by `xtreg, fe` has p < 0.001.
> Year effects are retained. The quadratic spending term has p = 0.5643 and
> is excluded from the main regression.
>
> Preferred specification: the observed-data PCSE model. Winsorizing all six
> continuous model variables at the first and 99th percentiles gives a similar
> childcare coefficient (-0.480, p = 0.0003). The winsorized version is a repeat
> of the same PCSE specification.
>
> File note: the 2019 single-year summary table is supplied in Excel form;
> a `.csv` copy with identical content is included in case Canvas rejects the
> Excel format.

## 4. After 18 Nov

Sultana drafts the 11 Dec paper from `docs/COURSE_REQUIREMENTS.md` §3,
`docs/LITERATURE_SOURCES.md`, and the four numbered logs. Any number in the
paper must be traceable to a log, and any new empirical work must be added to
a do-file and rerun so the log contains it.
