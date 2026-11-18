## 2026-11-18 — Clearer childcare and father-leave variable names

Renamed `ln_spending` to `ln_childcare` and `ln_leaveweeks` to
`ln_fatherleave`, including winsorized counterparts, diagnostics, figures,
regressions and exported variable references. Summary columns use childcare
and fatherleave names. The transformed definitions, controls, sample and
estimators are unchanged. Rebuilt data and reran all numbered scripts.

# Changelog

This file records the team's analysis and repository changes. The 17 November
documentation and formatting correction was prepared from GitHub main. It
does not by itself confirm that OneDrive or Canvas has been updated.

## 2026-11-18 — Dead defensive code removed from the build

A targeted audit asked whether every block in the do-files came from a real
problem the team had hit, or was only preventive armor. One block proved to be
vestigial from the earlier sample: `weeks_all` and the `leave_known` flag. On
the OECD panel, `leave_known` equals `!missing(fatherweeks)` on every row, so
the merge filter never dropped more than the fatherweeks condition alone, and
`weeks_all` was used by nothing downstream. The block is gone: the variable
generation, its four reform-year replaces, the flag, and the filter condition
are replaced by `!missing(fatherweeks)` with an updated comment. Four of the
five `duplicates report` calls that always printed zero duplicates were also
removed; the one before `reshape wide` stays because a duplicate would make
the reshape fail. The `capture noisily` wrapper on `xtserial` went away; the
command has never errored and should fail loudly if it ever does. The full
chain was rerun with no `r()` errors and every estimate is unchanged,
including the main coefficient and all diagnostics; `data_final` files no
longer carry the unused columns.

## 2026-11-17 — Mother-side paid leave added as a control

Sultana supplied her own regression showing the concern and the team decided
to add the mother-side control. The paid-leave text columns now include the
mothers' total paid weeks column from the same PF2.5 workbook, exported into
`oecd_leave_timeseries.csv` as `total_paid_mothers_raw`. France reports a
short and a long option in that column, and the do-file takes the short one,
matching the father-side treatment. The mother weeks lag, its 10-week unit
and its ln(1+x) form mirror the father weeks exactly, and the intermediate
file is renamed `tmp_leave_weeks.dta` since it now carries both. Every model
adds `ln_motherweeks`: diagnostics, the main PCSE, no-trends, levels, the
quadratic check, the subset runs, a fifth build-up column and the sixth
winsorized variable. The estimation sample stays at 347 because the mother
gaps fall outside it. The childcare coefficient moves from −0.4734 to
−0.4721 (SE 0.135, p = 0.0005) and the mother control itself is insignificant
(+0.021, SE 0.033, p = 0.538), so the association is specific to childcare
spending rather than paid leave. The four Word tables were re-exported with
the new numbers, so the earlier manual formatting no longer applies and needs
to be repeated before submission. OneDrive was rerun from `data_raw` with no
`r()` errors; local logs are 606 / 451 / 659 / 808 lines.

## 2026-11-17 — Restore the full workflow project settings

The project keeps the complete Workflow 18 master structure. The master sets
the run switches and the four store_log switches. Each numbered do-file opens
and closes its own log inside the store_log condition. The direct logging form
from the previous entry left the master with run switches but the child files
without matching log switches, which mixed the two patterns in section 18.5.
Restoring the switches returns every file to the same template. Regression
commands, data, estimates and comments are unchanged. The earlier entry stays
in the record because it describes what was done at that time.

## 2026-11-17 — OneDrive rerun for the direct-log chain

Copied the five revised do-files to the OneDrive package and reran the master
from the frozen raw inputs. Every estimate matches this repository and there
are no `r()` errors. The four formatted Word tables were kept from this
repository because a rerun overwrites them with raw exports. Local logs are
565 / 434 / 643 / 677 lines, all under the page limit, and were copied back
here so both copies are reproducible. The log figures in HANDOVER and
SUBMISSION_STATUS were updated to these local counts.

## 2026-11-17 — Save logs directly without optional switches

Removed the four `store_log_*` globals and the conditional log wrappers.
Each numbered do-file now uses `capture log close`, `log using ..., text replace`,
and a final `capture log close`. The master still controls which numbered
files run. This simplifies the optional Workflow 18 log-switch example to
the direct Test7 logging form. Regression commands, data and results are
unchanged. Existing comments were retained except wording tied to the removed
switches. Logs were regenerated from the final do-files.

## 2026-11-17 — OneDrive synced to the Test7 PCSE AR1 chain

Copied the four revised do-files to the OneDrive package and reran the master
there from the frozen raw inputs. Every estimate matches this repository, the
panel CSV is byte-identical, and there are no `r()` errors. The four formatted
Word tables were kept from this repository because a rerun overwrites them with
raw exports. Local logs are 567 / 436 / 645 / 679 lines, all under the page
limit, and were copied back here so both copies are reproducible.

## 2026-11-17 — Keep lagged log GDP per capita as the sole GDP control

Removed GDP growth at the user's request, including its generation, sample
restriction, descriptive statistics, regressions and winsorization. The WDI
raw snapshot is preserved. The four-column build-up adds father leave, GDP
per capita and leave spending in sequence. All five continuous model variables
are winsorized in the repeat. The Test7 PCSE AR(1) estimator, country and year
effects, country trends, and the remaining controls are unchanged.

A full rerun from the raw inputs retains 23 OECD countries and 347 observations
(309 EU-target and 38 other OECD). Childcare is -0.473, p = 0.0005, and the
winsorized coefficient is -0.480, p = 0.0003. Without trends it is +0.090,
p = 0.5488. Current documentation and all exported tables were updated.
Lagged log GDP per capita is described as an economic development control,
rather than a Solow growth model or an employment-gap convergence variable.

## 2026-11-17 — Use the Test7 PCSE AR1 workflow

Following the user's instruction, removed VCE options and the extra robust
comparison. Reported main, comparison, subset, build-up and winsorized models
now use `xtpcse ..., het corr(ar1)`. The existing data construction, controls,
fixed effects and country trends are unchanged. The initial `xtreg, fe` and
diagnostic sequence remain. Country effects use the F test printed by `xtreg`.
Only obsolete comments on the removed regression blocks were removed.

Reran the full master from the frozen raw inputs. Main childcare is -0.477
(p = 0.0004), winsorized -0.481 (p = 0.0003), without trends +0.103
(p = 0.4925), and the level comparison -7.735 (p = 0.0044). Sample sizes remain
347 overall, 309 EU-target, and 38 other OECD. Updated the current documents,
Canvas text and all four Word tables to the new common estimator. Earlier
entries below record historical estimators and results.

## 2026-11-17 — Comment pass across the do-files

The explanatory comments in all five do-files were edited for punctuation and
consistent wording. No executable line changed and the four data citations were
kept in their required format. The chain was rerun with every estimate unchanged
and logs now at 577 / 421 / 910 / 747 lines.

## 2026-11-17 — Code and comment audit corrections

Three do-file findings from a code and comment audit were fixed in both the
OneDrive package and this repository. In `0_master`, an unreferenced
`global controls` and its inaccurate comment were removed; the controls are
written explicitly in every regression. In `1_build_data`, the header now names
the file actually read (`oecd_leave_timeseries.csv`, not the source workbook),
and the two `weeks_all` slash-option `replace` lines were removed because they
never changed a value. `CODE_CONVENTIONS` now records the module 18 banner
exception, the removal of the dead global and no-op replaces, and why the
winsorize-loop "(0 real changes made)" lines are expected. The full chain was
rerun with no `r()` errors and every estimate unchanged; the build log is now
582 lines.

## 2026-11-17 — Interpretation and Word presentation aligned with the logs

Corrected the childcare magnitude to the local elasticity beta*x/(1+x),
about -0.20 at the sample mean. Removed claims that every specification is
negative and significant. README, handover, and Canvas text now explicitly
report the no-trends result of +0.131 (clustered p = 0.5181). Clarified that
GDP growth is the WDI annual percentage growth series and that the estimation
sample spans 2001–2023.

Formatted all four current Stata-exported Word tables with distinct model
headings, coefficients and SEs together, explicit country and year FE and
country-trend rows, and standard-error and sample notes. Regression code,
data, and logged estimates are unchanged. Rerunning Stata overwrites this
post-export formatting, which must then be repeated.

Moved the earlier single-file PCSE do-file, log, and Word table together into
`legacy/prior_pcse/`, with a provenance note separating their old coefficients
from the current numbered chain.

## 2026-11-17 — Clustered reference inference and an honest no-trends report

Two corrections from an independent review of the repository. (1) The
"no-trends comparison" in `3_results_261109.do` omitted `i.country_id`; the
comment said the comparison keeps country and year effects but the code
estimated year effects only. Fixed: the true two-way-FE, no-trends estimate is
+0.131 (clustered SE 0.199, p = 0.518), which shows the negative association
is identified relative to each country's own trajectory, and the documents
now report this openly wherever the headline appears. The trend terms stand on
the Barcelona-targets logic: countries started from different childcare
systems and expanded along different institutional paths. (2) The 16 November
source set wrongly stated that the course does not demonstrate cluster-robust
options; the lecture note "Preparing for Panel Data Analysis" demonstrates
`vce(cluster id)` verbatim and says "Always cluster your SEs". The main
inference is now `vce(cluster country_id)` (headline −0.582, clustered
SE 0.172, p = 0.003), with unclustered robust SEs and PCSE AR(1) as
sensitivity checks; the handout joins the whitelist sources, and the
23-cluster shortfall against the note's 30-50 floor is disclosed. Revised
printed values: no-trends +0.131 (p = 0.518), quadratic p = 0.8891, level
comparison −9.456 (clustered p = 0.009), winsorized −0.581 (p = 0.002), EU
subset −0.566 (p = 0.005), other-OECD −0.327 (p = 0.149). Log sizes are now
586 / 423 / 911 / 749 lines.

## 2026-11-16 (evening) — OECD childcare chain becomes the current chain

The team adopted the OECD public-childcare panel as the primary and only
analysis, on the basis of the childcare work already on this branch. The
father-specific-leave design and all of its numbers are retired. Changes: the
`string()` / `F1.snapshot` leave corrections were replaced by literal numeric
replaces (no first-hand course source; the built panel is bit-identical);
`testparm i.country_id` was added after the LSDV model so the rubric's panel
fixed-effects test is in the log (F(22, 276) = 173.02, p < 0.001); the whole
chain was rerun (logs 551 / 417 / 622 / 835 lines, no `r()` errors, N = 347,
PCSE p = 0.0004); the OneDrive submission folder now holds only the childcare
deliverables and the retired father-leave files were archived outside it. The
`childcare-neal-261116` branch was aligned with the OneDrive folder and merged
into `main`; every handover document (README, HANDOVER, research decisions,
rubric red lines, course requirements, submission status, code conventions,
pitfalls, data citations, literature sources) was rewritten for the childcare
direction. The command whitelist lost the `string()` function and gained a
second documented exception (`real()` for the slash-text leave column).

## 2026-11-16 — Leave spending aligned with the SOCX TP512 release

`leave_gdp` is now built from a frozen SOCX TP512 extract (`oecd_socx_tp512_leave.csv`)
in `data_raw/`, the same release and access date as the TP521 childcare
extract; the `oecd_policy_donor.dta` intermediate is no longer read. A
line-by-line comparison against the donor snapshot confirmed the donor values
were an earlier TP512 vintage (99 percent within 0.005; the largest gaps were
published revisions of roughly 0.02 for Norway). The estimation sample is
unchanged at N = 347 and the merge structure is unchanged (427 matched, 50
SOCX-only absences, 582 spending-only rows). Revised printed values:
`ln_childcare` −0.582 (testparm F(1, 276) = 25.17), PCSE −0.477 (chi2(1) =
12.52, p = 0.0004), winsorized −0.581 (F(1, 276) = 26.62), no-trends −0.622,
quadratic p = 0.8318, year FE p = 0.2904, country FE F = 173.02, `xttest3`
chi2(23) = 5332.23, "other OECD" subset −0.327 (p = 0.349). The leave
spending merge now keeps SOCX-absent rows with a missing value so the sample
flag stays the single exclusion point.

## 2026-11-16 — Stata CheatSheet removed from the command whitelist

The permitted source list is now the COMET Notebook modules and the StataTest /
ECON490Quizzes question sets only. `StataCheatSheet_analysis_19.pdf` is no longer
a source, and commands that rested on it alone are out: `isid`, `count`,
`tempfile`, `recast double`, `dtable`, `collect export`, `column(index)`,
`note()`, `test coef = 0`, `lincom`, `margins`, `vce(cluster id)`, `vce(robust)`
and the `sheet()` / `cellrange()` / `firstrow()` import options. `docs/CODE_CONVENTIONS.md`
is rewritten accordingly, the documented exceptions fall from four to one, and
the two Chinese command indexes, `HANDOVER.md`, `TEAMMATE_NOTES.md` and
`COURSE_REQUIREMENTS.md` are updated. The do-files were deliberately left
unchanged in this round, so §7 of the code conventions records where each
removed command is still used. Those uses must be replaced before submission.

## 2026-11-15 (night, second) — guard removed; course-demonstrated cd line restored

The guard added earlier tonight used `confirm file`, `_rc` and `exit`, none of which appears anywhere in the course material, and the team rule is to prefer the fully permitted syntax whenever a change does not affect results. The guard is removed. The master instead opens with `capture noisily cd "<path>"` followed by `capture noisily dir`, which the course index demonstrates verbatim as the prefix-command form of the directory block; the header tells the reader to edit that one line to their own project folder. `docs/RESEARCH_DECISIONS.md` records both the relative-path attempt and this reversal, `docs/CODE_CONVENTIONS.md` is back to four documented exceptions, and a full rerun produced byte-identical numbered logs.

## 2026-11-15 (night) — wrong-working-directory guard in the master

Running the master from any directory other than the project root printed four
`file ... not found` errors and stopped, because every path in the do-files is
relative and `capture noisily` swallowed each failure. `0_master_261109.do` now
checks for `do_files/0_master_261109.do` before doing anything and exits with
`Wrong working directory: run this master from the project root ...` if the
check fails. The guard uses `capture confirm file` / `exit` / `display as
error`, which are not in the course handouts, so it is recorded as the fifth
documented exception in `docs/CODE_CONVENTIONS.md` §2: it touches no data and
cannot change any number. A full rerun from the project root produced
byte-identical numbered logs (md5-verified), confirming the guard is inert when
the working directory is correct.

## 2026-11-15 (late) — leave lag rebuilt on the policy panel; specification search declined

**The leave series and its lag are now built on the policy panel, before any
merge.** In the previous build `lag_fatherweeks10 = L1.fatherweeks10` was
computed inside the assembled panel, where a country-year exists only if the
outcome, the WDI controls and the SOCX spending figure are all observed. A
missing outcome in year t-1 therefore removed the lag in year t even when the
policy value for t-1 was known. Two consequences: the estimation sample was
decided by the availability of the dependent variable, and the treatment of the
policy lag was inconsistent with the GDP lags, which the same do-file already
builds on the full annual series before merging.

The construction moved into the policy block of `1_build_data_261109.do`, using
`encode` + `xtset` + `L1.` on the policy panel; the analysis loop now receives
`fatherweeks`, `fatherweeks10` and `lag_fatherweeks10` through the merge. No new
command and no new option was introduced.

Measured effect: **20 country-years return in each sample and no existing value
changes.** Europe 272 -> 292 estimation rows, OECD 443 -> 463 (348 with
`leave_gdp`). On the 272 and 443 overlapping rows the lag is identical; the
added rows are exactly the ones that were missing. Every headline number moves
in the conservative direction:

| | before | after |
|---|---|---|
| Europe, country-clustered LSDV | +0.668, p=0.065 | +0.617, p=0.113 |
| Europe, AR(1) PCSE | +0.560, p=0.007 | +0.493, p=0.021 |
| Europe, winsorized PCSE | +0.571, p=0.005 | +0.491, p=0.022 |
| OECD, three columns | p=0.352 / 0.583 / 0.746 | p=0.857 / 0.936 / 0.876 |
| DiD | -0.626, p=0.653 | unchanged |
| Event study | p=0.878 / 0.815 / 0.817 / 0.603 | unchanged |

The conclusion does not change and gets cleaner: the association is positive,
i.e. opposite to the hypothesis, and it is not significant under country
clustering. The build-up table now holds 348 observations in all four columns
and the subset table 463 = 350 + 113.

**A specification search proposed at the same time was declined.** The list was
country-specific linear trends, a lagged unemployment rate, lagged childcare
spending, replacing `leave_gdp` with its own lag, and a two-year lag as the
headline. Country trends consume 23 degrees of freedom in a 292-row panel, are
not demonstrated anywhere in the course material, and were already insignificant
in the earlier draft (0.500, p=0.426, N=266). The extra controls are not part of
"a single properly specified regression", and an interaction or extra term is
permitted only when it improves fit and theory predicts it. The two-year lag
gives -0.015 (p=0.961) on this data, so the reported significance does not
reproduce; selecting a lag length because one of them is significant is what the
assignment's "single properly specified regression" excludes. All five are
recorded as evaluated and declined in `docs/RESEARCH_DECISIONS.md`.

**Verification.** Full rerun from `data_raw`: no `r()` error; logs 753 / 354 /
866 / 1100 lines (15.1 / 7.3 / 18.1 / 22.9 pages, all under 25); the 2019
single-year table is unchanged at 23 rows; the two `note()` strings and the
Canvas comment draft were updated to the new sample sizes; the non-European
column now has 7 groups (one of them a single observation) and its note says so.

## 2026-11-15 (evening) — source refresh check, portable master, Chinese content merged

**Source vintages checked against the publishers.** Two of the five sources had a
November release; both were downloaded again and compared cell by cell with the
frozen snapshots.

- **OECD PF2.5** (`Last-Modified: 5 Nov 2026 08:56 GMT`, 272,022 bytes against
  the 4 Nov file's 279,582). The new workbook has 2,166 rows instead of 2,128,
  the extra rows being 2025; across the 2,128 overlapping country-years the
  `total_all_raw` and `total_paid_raw` cells are **identical**, zero changes.
  The file was replaced, and `keep if inrange(year,1970,2024)` drops the new
  2025 rows.
- **World Bank WDI** (`lastupdated: 2026-11-11`). Over 14,561 country-years for
  GDP per capita and 14,388 for GDP growth, **no value differs by more than
  1e-9**. The `.dta` snapshot was kept: it carries 14 variables including the
  World Bank metadata columns, and rebuilding it would change bytes without
  changing a number.
- **Eurostat** `lfst_hhacwnc` still reports `updated: 2026-09-10`, so no newer
  release exists. **SOCX** has no public version stamp.
- **ILOSTAT** `GED_PEPR_SEX_HHT_CHL_RT_A` was fetched again on 15 November
  through the ILOSTAT bulk download. The decompressed file is 18,854,904 bytes
  and 169,679 rows covering 2000-2026, and it is **byte-for-byte identical** to
  the snapshot, md5 `e45765c52e64a428dc28819e9d06e5a0` on both. The API endpoint
  still answers HTTP 200 with `Content-Length: 0`; only the bulk route works.
  Earlier notes that called this source impossible to re-download described the
  API route and were wrong about the bulk one.

After the PF2.5 replacement the whole chain was rerun from `data_raw`: all four
analysis CSVs and both table CSVs kept their md5, the four logs kept their line
counts (737 / 354 / 858 / 1087), and no `r()` error appeared. The two November
releases are therefore value-neutral for this project. `docs/DATA_CITATIONS.md`
§8 records the check.

**Master is now portable.** The SharePoint library was renamed on 15 November
(`... - 2_Team` became `... - econ490_project`), which left the single
`capture noisily cd "<absolute path>"` line pointing at a directory that no
longer exists. An edit had already been made in OneDrive to the new absolute
path, with backslashes, which would break again on the next rename and on any
other machine. The line was removed instead. `0_master_261109.do` now opens with
`capture noisily dir` and `global proj_main "."`, so every path is relative to
the working directory and the folder can be renamed, moved, or opened on macOS
without touching the code. The header states that the file must be run from the
project root, and the first `use` in `1_build_data` names the missing file if it
is not.

**Chinese material merged into English and removed.** Eight Chinese files were
deleted from `docs/`, with their content folded into the English set:
the two command indexes into `docs/CODE_CONVENTIONS.md` §7 (module-by-module
provenance) and §2 (documented exceptions); the interaction-term decision into
`README.md` §7 and `RESEARCH_DECISIONS.md`; the sample-scope note and the
float/double note into `RESEARCH_DECISIONS.md`; the rubric gap audit into
`COURSE_REQUIREMENTS.md` and `SUBMISSION_STATUS.md`; the 13 November status
report into `HANDOVER.md`. `docs/HANDOVER_INDEX.md` §4 records where each one
went. The repository now contains one Chinese-free document set; only the file
names of the removed documents remain, in that table.

## 2026-11-15 (afternoon) — PR triage, README as entry point, code conventions

**Two open pull requests reviewed and both declined.**

PR #2 (`zja42/main`, base `29eb0d3`, `mergeable_state = dirty`) was closed. It
restores live official-source imports ("the build reads official data online"),
re-adds `display "Master do-file finished."`, re-adds comments that cite
"Module 18" and "Checklist", adds a paper-writing instruction inside the do-file
("the paper must explain why theory predicts non-linearity") and adds a defence
of the `generate` + `recast double` + `replace` sequence. Those are the four
categories the team removed on 14 November. Its base is four commits behind main,
so it could not merge without resolving conflicts anyway.

PR #3 (`oecd-primary`, base `427e040`, clean) was closed with one element
adopted. The adopted part is `test lag_fatherweeks10 = 0` after the main
regressions: the course's own post-estimation material shows `test 变量 = 0`, and
the three lines make the quoted p-values traceable. Everything else was
declined: it makes the OECD panel the primary analysis, which is a change of
research design rather than a code improvement; it runs `1_build_data` and
`4_tables` before `log using` opens, so three of the five do-files produce no log
at all; it deletes the model equation and the "associations, not causal effects"
annotation; it removes `cd` and `dir` from the master; it demotes `HANDOVER.md`
in the README to "records the earlier European-primary version"; and it leaves
`tables/results_europe_robust_261109.docx` orphaned while adding a second
robustness table.

**`README.md` rewritten as the single entry point.** It now states the reading
order, what each document is for and when to read it, the nine closed decisions,
the eight pitfalls that have already caused damage, what each file type is for,
why there is no `pay_c` term, and the rules under which pull requests are
reviewed. The section "Before you review or edit any do-file" is the checklist a
new teammate should follow before touching code.

**`docs/CODE_CONVENTIONS.md` added.** An English restatement of the permitted
command set by category, the banned commands, the three documented exceptions
(`egen min()/max()`, `generate` + `recast double` + `replace`, and
`dtable ..., continuous(..., statistic(...))`), the comment rules with a
forbidden-examples table, the expected coding level, the standard do-file
skeleton and six pre-commit checks. It is the gate any future patch must pass and
it cites the course handouts by filename only.

**Comment wording fixed in five places.** `1 = run build.do` referred to a file
that does not exist; "locked panels" and "apply the existing sample rule" are
internal process language; "author-date form" described a citation style inside
a data comment. All five were rewritten to say what the code does.

**Verification.** Full rerun from `data_raw`: no `r()` errors; logs 737 / 354 /
858 / 1087 lines (14.7 / 7.3 / 17.9 / 22.6 pages); all four analysis CSVs and
the 2019 summary CSV keep their md5. The three new `test` lines print
`p = 0.0651` (Europe LSDV clustered), `p = 0.0069` (Europe AR(1) PCSE) and
`p = 0.5832` (OECD AR(1) PCSE), matching the numbers already quoted.

## 2026-11-15 (early morning) — complete winsorization, one estimation sample, Word summary table

Four gaps raised by an external review of commit `2995794` were checked against
the rubric PDF and the current logs and then fixed.

**Full winsorized repeat (rubric item 7).** `4_tables_261109.do` now winsorizes
all five continuous variables at 1/99, not just the outcome and log GDP. Country
and year dummies keep their coding. Observations actually changed: outcome 4,
lagged leave weeks 0, log GDP 4, GDP growth 5, leave spending 5. Lagged leave
weeks has p1=0 and p99=2.86, so no row moves; the count is printed to the log so
the zero change is on record rather than implied. The winsorized PCSE coefficient
is +0.571 (SE 0.206, p=0.005) against +0.560 (p=0.007) unwinsorized: same sign,
same significance, slightly larger magnitude, so the unwinsorized model remains
the preferred specification.

**One estimation sample across the build-up table (rubric item 8).** The four
columns previously used 443 / 443 / 443 / 333 observations, which confounds
"added a control" with "changed the sample". All four now use the same 333
observations, built with `generate` + `missing()` on the full control set. The
table note states this. The `3_results` OECD table keeps its own 443 / 443 / 333
design because those columns are descriptive, not a build-up.

**Word version of the 2019 summary table (rubric item 6).** Rubric asks for
"an Excel or Word document" and the Canvas upload list has no `.xlsx`, so
`2_descriptive_261109.do` now also writes
`tables/descriptive_2019_oecd_261109.docx` with
`dtable ..., continuous(... statistic(n mean sd min max)) export(...)`. The N is
reported per variable, not once for the table: `leave_gdp` covers 20 of the 23
rows, the other four cover all 23. The Excel and CSV versions are unchanged,
byte for byte.

**Column headers.** The build-up and subset tables now use `column(index)`, the
form shown in the Stata cheat sheet, instead of `column(dvlabel)`, which
repeated the dependent-variable name once per column. A build-up table with four
identical headers is unreadable on export.

**Canvas comments draft corrected.** The draft said N=295 next to the main
regression; 295 is the input panel, while every Europe regression is estimated
on 272 rows. It also now separates the two kinds of observation loss (rows that
never matched, and rows that matched but drop because `leave_gdp` is missing) and
records both country-clustered p-values: `xtreg, fe vce(robust)` gives p=0.054
and explicit LSDV clustering gives p=0.065, with the same conclusion.

**Where the new code went.** The quadratic and winsorized checks were moved from
`3_results` to `4_tables`: with the extra code `3_results` reached 1257 lines
(~26 pages), over the 25-page limit. Sizes after the move: 739 / 354 / 834 /
1087 lines (14.8 / 7.3 / 17.4 / 22.6 pages at a conservative 80-character wrap).
Five do-files and four logs are unchanged; tables are now ten.

**Verification.** Full rerun from `data_raw`: no `r()` errors, four logs close
normally, all four analysis CSVs and the 2019 summary CSV keep their md5, and
every coefficient, SE, p-value and N in `3_results_261109.log` is unchanged. The
headline results still read +0.668 (cluster p=0.065), AR(1) PCSE +0.560
(p=0.007), DiD -0.626 (p=0.653), OECD p=0.352 / 0.583 / 0.746.

## 2026-11-14 (evening) — English handover, exact citation dates, subset decision

**Repository reorganised for an English-only reader.** Added `HANDOVER.md` at
the root as the single authoritative handover, plus `docs/COURSE_REQUIREMENTS.md`,
`docs/RESEARCH_DECISIONS.md`, `docs/PITFALLS_AND_CORRECTIONS.md`,
`docs/DATA_CITATIONS.md`, `docs/SUBMISSION_STATUS.md` and
`docs/LITERATURE_SOURCES.md`. Rewrote `README.md`, `docs/HANDOVER_INDEX.md`,
`docs/TEAMMATE_NOTES.md`, `docs/SYNC_STATUS_2026-11-14.md` and the Sultana
task note. All new documents justify rules with filenames or URLs only. The
Chinese-language handover previously uploaded to the root and to `docs/` was
removed from this mirror (the team keeps its own Chinese copy locally).

**"How to cite" researched from the publishers' own guidance** and written into
`1_build_data_261109.do`. Sources: the OECD Style Guide (Fourth Edition)
"Citing data" section, the ILOSTAT "Dissemination and analysis / Citations"
page, the World Bank "Summary Terms of Use", the EU data-provider manual's
"Data citation" page and Eurostat's DOI documentation, plus the SOCX dataset DOI.
All five data citations now carry the exact access date **14 November 2026**
(previously "October 2026"), plus version information read from the five saved
source PDFs: Eurostat DOI 10.2908/lfst_hhacwnc (last update 10/09/2026 15:00),
OECD PF2.5 updated November 2026, WDI last updated 11 November 2026, and
https://doi.org/10.1787/data-00167-en for SOCX.

**Non-European subset column: kept.** Rubric item 9 requires three columns and
rubric item 10 requires overlapping histograms for the same subsets; deleting
the column would lose both. The split (19 European / 7 non-European OECD
members) is theory-driven via supranational EU leave mandates. The column has
6 groups and 102 observations, so `4_tables_261109.do` now states in its note
that it is shown for the three-column comparison only and must not be read as
a policy effect. Also corrected a stale "three numbered do-files" phrase in
`0_master_261109.do`.

**Overlapping histogram cleaned up.** `2_descriptive_261109.do` now uses the
course's literal two-group histogram syntax: `bin()` and `subtitle()` (neither
appears in the course handouts) were removed and `lcolor(black)` was added so
both overlaid series stay visible. The figure still shows the same substantive
fact — non-European OECD members cluster at zero weeks of father-specific leave.

**Full rerun and verification (two passes).** No `r()` errors; logs
739 / 330 / 1113 / 560 lines (~15 / 7 / 22 / 11 pages); all four analysis CSVs,
the 2019 summary-table CSV and all 2396 result floats unchanged.
`log_files/3_results_261109.log` is byte-identical apart from its header.

## 2026-11-14 — rubric compliance, official-source decision, fifth numbered do-file

**Official sources: adopted as citations, not as live imports.** Neal's PR #1
(commit `8efda45`, merged as `29eb0d3`) changed `0_master` and `1_build_data`
to read five official endpoints at run time. We reverted the live reads and
kept the provenance information. Measured on this machine: ILOSTAT
`GED_PEPR_SEX_HHT_CHL_RT_A` returns HTTP 200 with 0 bytes for both `.csv` and
`.csv.gz`; the Eurostat SDMX 3.0 response is 12.7 MB and did not complete in
20 s; the other three endpoints respond normally. Beyond reliability, live
revisions would break the course requirement that the submitted log be created
by the do-file and reproduce the reported numbers. The five sources are now
cited in AER / Chicago author-date form in `1_build_data_261109.do`; frozen
snapshots remain in `data_raw/`. Also reverted `do_dir = "${proj_main}"` and
`do` (the Workflow Guide uses `${proj_main}/do_files` and `capture noisily do`),
but kept the portable idea: `global proj_main "."` with one `cd` line to edit.

**Rubric gaps closed** (Canvas assignment "Econometric Files for Final Paper",
100-point rubric, received 18:52): AER data citations in the do-file; a 2019
summary table restricted to `lag_fatherweeks10 != .` (23 observations,
exported as both .xlsx and .csv because Canvas file types exclude .xlsx); a
four-column build-up table with the main regressor first and a
"Year FE: yes; Country FE: yes" note; a three-column subset table (all 26 /
European 19 / non-European 7 OECD countries) with the same core specification;
an overlapping two-subset histogram; comments on merge non-matches, the
preferred unwinsorized specification, and why the non-linear term was dropped.

**Subset decision.** Full sample is the 26-country OECD panel, representative
year 2019, as agreed by the team. Subsets are European vs non-European OECD
members: a defensible institutional split (EU-level leave directives versus
no supranational mandate), and no new data are needed. Grouping by initial
leave generosity was tested and rejected because the median initial
father-specific entitlement is 0, putting all 26 countries in one group. The
core specification omits `leave_gdp` because SOCX coverage is sparse outside
Europe; using full controls would leave only 33 observations in the
non-European column. Even so that column has 6 clusters and 102 observations,
and its coefficient (23.576) is a small-sample artifact — the table note warns
against interpreting it.

**Fifth numbered do-file.** Adding six regressions pushed `3_results` to 1659
lines (~30-33 pages), over the assignment's 25-page log limit. The build-up
and subset tables now live in `4_tables_261109.do` with their own
`4_tables_261109.log`; the Workflow Guide allows separate do-files for tables.
Final log sizes: 732 / 331 / 1113 / 558 lines, all under 25 pages.

**Verification.** Full rerun from `data_raw`: no `r()` errors, all four numbered
logs generated by their do-files, all 2396 original floating-point numbers in
`3_results_261109.log` unchanged, all four analysis CSV md5 unchanged, five
do-files, four logs, nine tables, five figures, all filenames ASCII.

## 2026-11-14 — full deliverables mirror and whitelist cleanup

Added to this mirror: `tables/` (5), `figures/` (4), `data_raw/` (8),
`data_final/` (10), plus `CHANGELOG.md`, `docs/HANDOVER_INDEX.md` and
`docs/TEAMMATE_NOTES.md`.

Do-file changes on this date, all verified by a full rerun from `data_raw`:

- Removed `stringcols(_all)` and `allstring` from the import commands. This is a
  float/double storage-precision change only: three rate columns differ by at
  most 1.03e-05 percentage points (Europe) and 7.08e-06 (OECD); every reported
  coefficient, standard error, p-value and sample size is unchanged. The only
  discrete side effect is that outcome winsorization now changes 4 instead of 5
  observations.
- Replaced `cond()`, `[_n-1]` subscripts and `egen max(cond())` with the
  course-taught `L1.` / `F1.` operators, `generate` + `replace`, and
  `egen min()` after `encode` + `xtset` + `sort`.
- Deleted four `destring` lines that had become no-ops (log printed
  "already numeric; no replace").
- Merged two verbatim-duplicated policy-history build blocks into one;
  `1_build_data_261109.do` went from 357 to 275 lines.

Verification: four data CSVs keep their md5 across the last three cleanups;
all 2396 floating-point numbers in `3_results_261109.log` are unchanged; no
`r()` errors; all three numbered logs close normally. Main results are still
+0.668 (cluster p=0.065), AR(1) PCSE +0.560 (p=0.007), DiD -0.626 (p=0.653),
OECD columns p=0.352 / 0.583 / 0.746. Conclusion: no robustly significant
policy effect / conditional association.

## 2026-11-14 — do-files refreshed (web upload)

Four numbered do-files uploaded, including the 275-line `1_build_data`.

## 2026-11-13 — repository created

Initial commit with four do-files and a short README.

## Standing notes

- Europe is the primary sample; OECD is an extension. The two are never pooled.
  See `docs/ECON490_SAMPLE_SCOPE_NOTE_261112.txt` for the course-based rationale.
- The `weeks x pay_c` interaction is not in the main model. See
  `docs/ECON490_DECISION_2026-11-11.txt` and
  `docs/ECON490_PRECISION_STYLE_DECISION_261114.txt`.
- Historical significant p-values are retired and must not be reinstated.
- Default sync target is OneDrive only. This GitHub mirror is updated only on
  explicit instruction.
