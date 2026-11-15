# Submission status — 18 Nov 2026 Econometric Files

Last updated 15 November 2026. This is the actionable checklist. Code work is
finished and verified; everything left is a manual team action.

## 1. Done and verified

- Five numbered do-files, four numbered logs, ten tables, five PNG figures,
  eight `data_raw` inputs, ten `data_final` outputs.
- Full rerun from `data_raw` on 15 Nov: no `r()` errors; all four analysis CSVs
  and the summary-table CSV keep their md5; every headline coefficient, SE,
  p-value and N in `3_results_261109.log` is unchanged. Logs are
  737 / 354 / 858 / 1087 lines. With 80-character wrapping and a conservative
  50 display lines per page that is about 14.7 / 7.3 / 17.9 / 22.6 pages, all
  under the 25-page limit.
- The quadratic and winsorized checks moved from `3_results_261109.do` to
  `4_tables_261109.do` so neither log exceeds the page limit. Their numbers now
  live in `log_files/4_tables_261109.log`; the "2396 floats" figure from an
  earlier verification no longer applies because that log was restructured.
- All five data sources cited in the do-file with the exact access date
  14 November 2026 (see `docs/DATA_CITATIONS.md`).
- 2019 single-year summary table, restricted to rows with the main regressor,
  in three formats: `.csv`, `.xlsx` and now
  `tables/descriptive_2019_oecd_261109.docx` (Word satisfies the rubric's
  "Excel or Word document" while Canvas also accepts the `.csv`). The Word
  version reports N, mean (sd), min and max per variable, so the reading
  `leave_gdp` covers 20 of the 23 rows is visible rather than hidden behind a
  single sample size.
- Build-up table with all four columns on the same 358 observations:
  `tables/results_buildup_261109.docx`.
- Three-column subset table with its all-countries column on the full 473
  observations, so 359 + 114 adds back to 443:
  `tables/results_subsets_261109.docx`.
- Full 1/99 winsorized repeat covering all five continuous variables; changes
  4 / 0 / 4 / 5 / 5 observations and moves the main coefficient from +0.560 to
  +0.571 with the same sign and significance.
- Overlapping two-subset histogram: `figures/histogram_leave_byregion_261109.png`.
- Comments in the do-files about unmatched merges, the preferred unwinsorized
  specification, and why the non-linear term is not used.
- Three `test lag_fatherweeks10 = 0` lines in `3_results_261109.do` print the
  exact p-values behind the quoted numbers: Europe LSDV clustered
  `F(1,22) = 3.77`, `p = 0.0651`; Europe AR(1) PCSE `chi2(1) = 7.29`,
  `p = 0.0069`; OECD AR(1) PCSE `chi2(1) = 0.03`, `p = 0.8599`.

## 2. Manual actions still required

| # | Action | Owner | Why |
|---|---|---|---|
| 1 | Confirm the nine directories are synced in the OneDrive client | Hansen | Canvas submission comes from OneDrive, not GitHub |
| 2 | Upload to Canvas: 5 `.do`, 4 `.log`, `.csv` copies from `data_raw/` and `data_final/`, the `.csv`/`.docx` tables, and 5 `.png` figures | Team | Canvas accepts only `log, csv, png, do, docx, jpeg`; do **not** upload `.xlsx` or `.dta` |
| 3 | Paste the Canvas comments in §3 below | Team | 5 pts for stating whether results support the hypothesis; part of the 8 merge points |
| 4 | Edit the exported Word tables: add explicit "Year FE: yes" / "Country FE: yes" rows, check stars, SEs, N, headings | Sultana | The assignment says the exported table "will need to be edited after it has been exported"; `etable` cannot add those rows with permitted commands |
| 5 | Open each numbered log in Word with the final font and margins and confirm the printed page count | Team | The page estimates above are conservative calculations, not a rendering; `4_tables` has the least margin |
| 6 | Check whether the Canvas assignment page has an extra upload field or naming rule, and confirm the live due date | Team | The exported PDF header says "Due No Due Date" and its body says "March 23rd"; Course Outline p.14 says 18 Nov |
| 7 | Fill `literature/` with the ten article PDFs and `paper/` with the draft | Sultana | Both folders are still empty; 11 Dec paper needs ≥8 peer-reviewed economics articles |
| 8 | Write the group's written freeze of the final model, including how the instructor's verbal "OECD only" suggestion is recorded | Team | Prevents another round of specification drift |
| 9 | Decide the paper wording for the 23-cluster limitation and whether to ask the TA about the two minor command extensions | Team | See `docs/RESEARCH_DECISIONS.md` §5 |
| 10 | Confirm 2 Dec and 7 Dec poster requirements; 11 Dec final paper deadline | Team | `ECON 490 Course Outline.pdf` p.14 |

A stale second copy of the project exists in a personal OneDrive folder with
only 4 do-files, 3 logs, 5 tables and 4 figures plus old notes in its root.
It is **not** the submission folder. The authoritative folder is the team
`... - 2_Team/econ490_project` one with nine clean directories.

## 3. Ready-to-paste Canvas comments (English)

> Our results do not support the hypothesis. The primary European panel
> contains 23 OECD countries over 2006-2019 (295 country-year observations);
> the two-way fixed effects regressions use the 272 observations with complete
> data on all variables. The coefficient on lagged father-specific paid leave
> is +0.668 with country-clustered standard errors (SE 0.344, p=0.065) in the
> LSDV specification; the within estimator with the same 23 country clusters
> gives p=0.054. Both are wrong-signed relative to H1 and neither is
> significant at 5 percent. The DiD estimate is -0.626 (p=0.653), all
> event-study leads and lags are insignificant, and the OECD extension columns
> give p=0.846 / 0.860 / 0.467. An AR(1) PCSE sensitivity check gives +0.560
> (p=0.007); we do not use it as the headline inference because the course
> note "Preparing for Panel Data Analysis" requires clustered standard errors,
> and with only 23 clusters our inference is already optimistic. We therefore
> report no robust evidence of a policy effect, only a conditional association.
>
> Merge note: all merges are performed inside `1_build_data_261109.do`. Two
> distinct kinds of observation loss occur and neither is an error. (i) Rows
> that do not match: the Eurostat source contains country groups outside the
> 23-country sample (568 rows dropped), and the OECD policy workbook contains
> country-years outside the research window or without verified entitlement
> values (631 rows from the using file in the Europe merge; 855/430 in the
> OECD merge); these are excluded by design after harmonising country names and
> years. (ii) Rows that do match but still leave a regression: WDI GDP controls
> merge to all 295 European and all 477 OECD country-years, but taking lags and
> missing values in public leave spending (`leave_gdp`, whose SOCX coverage is
> sparse outside Europe) reduce the OECD extension columns to 358 / 358 / 473
> observations; the third column drops that covariate to show the loss. For the
> same reason the build-up table holds the sample fixed at 358 observations in
> all four columns.
>
> Subset note: the three-column subset table splits the 26 OECD countries
> into 19 European and 7 non-European members, following the difference in
> supranational leave mandates. The non-European column has 7 country
> groups and 114 observations and is shown for the required comparison only;
> its coefficient must not be read as a policy effect.
>
> Preferred specification: the unwinsorized AR(1) PCSE model with country and
> year fixed effects. The 1/99 winsorized repetition winsorizes all five
> continuous variables (the outcome, lagged father-specific leave, lagged log
> GDP per capita, lagged GDP growth and public leave spending); country and
> year dummies are left unchanged. It changes 4 / 0 / 4 / 5 / 5 observations
> respectively and moves the main coefficient from +0.560 to +0.571, keeping
> the same sign and significance, so we do not prefer it. The quadratic term
> is insignificant and does not improve fit, so it is reported only as
> robustness, consistent with the assignment instruction to add non-linearity
> only when it improves the model and has a theoretical justification.
>
> File note: the 2019 single-year summary table is supplied as a Word document
> and as `.csv`; the `.xlsx` version is kept locally because Canvas does not
> accept `.xlsx`.

## 4. After 18 Nov

Sultana drafts the 11 Dec paper from `docs/COURSE_REQUIREMENTS.md` §3,
`docs/LITERATURE_SOURCES.md`, and the four numbered logs. Any number in the
paper must be traceable to a log, and any new empirical work must be added to a
do-file and rerun so the log contains it.
